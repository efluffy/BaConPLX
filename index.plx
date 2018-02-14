#!/usr/bin/perl
use warnings;
use Cwd 'abs_path';

# Get script WD
my $cwd = abs_path($0);
$cwd =~ s/^(.*?)\/index.plx/$1/;
# Essential Vars
our $page_file = '';
our %headers = ('content-type', 'text/html;charset=utf-8');
our $base_dir = $cwd;
our $libs_dir = 'libs';
our $base_libs_file = 'base.plx';
# Location Vars
our @uri_data = split('/', $ENV{'REQUEST_URI'});
# Controller Locations
our $controller_dir = 'controllers';
our $home_controller = 'home';
# Model Locations
our $model_dir = 'models';
# View Locations
our $view_dir = 'views';
# View configurations
our $left_view_tag = '<!';
our $right_view_tag = '!>';

# Include base lib
if ( -f "$base_dir/$libs_dir/$base_libs_file" ) {
    require "$base_dir/$libs_dir/$base_libs_file";
} else {
    # Add function for error HTML page
    print 'Base Lib not found!';
    exit;
}

# Load Controller
our $controller = $uri_data[2] ? $uri_data[2] : $home_controller ;
if(! -e "$base_dir/$controller_dir/$controller.plx") {
  $controller = $home_controller;
}
load_controller($controller);

# Load Controller Method
$param_cut = 3;
$method = 'default';
if( $uri_data[3] && defined(&{$uri_data[3]}) ) {
    $method = $uri_data[3];
    $param_cut = 4;
}
my @params = @uri_data;
splice(@params, 0, $param_cut);
&$method(@params);

# Load Page
page_load();
exit;
