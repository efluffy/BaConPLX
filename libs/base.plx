sub include {
    my ($path) = @_;
    if ( -f $path ) {
        require $path;
        return true;
    }
    return false;
}

# HTTP functions

sub add_header {
  my ($header_name, $header_content) = @_;
  $headers{lc($header_name)} = $header_content;
}

sub remove_header {
  my($header_name) = @_;
  delete $headers{lc($header_name)};
}

# Load functions

sub load_controller {
    my ($controller) = @_;
    include("$base_dir/$controller_dir/$controller.plx");
}

sub load_model {
    my ($model) = @_;
    include("$base_dir/$model_dir/$model.plx");
}

sub load_view {
    my ($view, %view_data) = @_;
    open (FILE, "$base_dir/$view_dir/$controller/$view.plx");
    $view_file = do { local $/; <FILE> };
    if (%view_data) {
        foreach my $key (keys %view_data) {
            $view_file =~ s/$left_view_tag$key$right_view_tag/$view_data{$key}/g;
        }
    }
    page_append($view_file);
}

# Page functions

sub page_set {
    my ($string) = @_;
    $page_file = $string;
}

sub page_append {
    my ($string) = @_;
    $page_file .= $string;
}

sub page_load {
    @chars = split("", $page_file);
    my $j = length($page_file);
    @blocks = ();
    $block_index = 0;
    $in_code = false;
    for(my $i=0 ; $i<$j ; $i++) {
      if($in_code eq false and $chars[$i] eq '<' and $chars[$i+1] eq '%') {
        $in_code = true;
        $block_index++;
      }
      if($in_code eq false and $chars[$i] eq "'") {
        $chars[$i] = "\\'";
      }
      if($in_code eq true and $chars[$i-1] eq '>' and $chars[$i-2] eq '%') {
        $in_code = false;
        $block_index++;
      }
      $blocks[$block_index] .= $chars[$i];
    }

    $clean_view = '';
    $j = scalar(@blocks);
    for(my $i=0 ; $i<$j ; $i++) {
      if($blocks[$i] =~ /^\<\%.+?\%\>$/gmsi) {
        $blocks[$i]  =~ s/^\<\%(.+?)\%\>$/$1/gmsi;
      } else {
        $blocks[$i] = "print '".$blocks[$i]."';";
      }
      $clean_view = $clean_view . $blocks[$i];
    }

    for my $header (keys(%headers)) {
      print "$header: ".$headers{$header}."\n";
    }
    print "\n";

    $cache_file = "/tmp/baconplx_cache_view_$$.plx";
    open(my $view_cache, '>', $cache_file);
    print $view_cache $clean_view;
    close $view_cache;
    require $cache_file;
}

return true;
