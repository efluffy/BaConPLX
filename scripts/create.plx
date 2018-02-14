#!/usr/bin/perl
use warnings;
use Cwd 'abs_path';

# Get parent directory
my $pwd = abs_path($0);
$pwd =~ s/^(.*?)\/create.plx/$1/;
$pwd =~ s/^(.+?)\/[^\/]+?$/$1/;

$output = '';
$object = '';
$name = '';

if(!$ARGV[0]) {
  print "No object provided\n";
  exit;
} else {
  $object = $ARGV[0];
}

if(!$ARGV[1]) {
  print("No name provided\n");
  exit;
} else {
  $name = $ARGV[1];
}

if(-e $pwd."/".$object."s/".$name.".plx") {
  print("$object $name already exists\n");
  exit;
}

if($object eq 'controller') {
  $output .= "sub default {\n#    my (\$param1) = \@\_;\n#    load_view('$name');\n}\n\n";
  if($ARGV[2]) {
    $last_entry = scalar(@ARGV)-1;
    @methods = @ARGV[2..$last_entry];
    for my $method (@methods) {
      $output .= "sub $method {\n#    my (\$param1) = \@\_;\n#    load_view('$method');\n}\n\n";
    }
  }
}

if($object eq 'model') {
  if($ARGV[2]) {
    $last_entry = scalar(@ARGV)-1;
    @methods = @ARGV[2..$last_entry];
    for my $method (@methods) {
      $output .= "sub $method {\n#    my (\$param1) = \@\_;\n}\n\n";
    }
  }
}

$output .= "return true;";

$file_to_write = $pwd.'/'.$object.'s/'.$name.'.plx';

open(my $output_file, '>', $file_to_write);
print $output_file $output;
close $output_file;

`chmod +x $file_to_write`;
