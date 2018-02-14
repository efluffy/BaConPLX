#!/usr/bin/perl
use warnings;
use Cwd 'abs_path';

# Get parent directory
my $pwd = abs_path($0);
$pwd =~ s/^(.*?)\/restore.plx/$1/;
$pwd =~ s/^(.+?)\/[^\/]+?$/$1/;

$object = '';
$name = '';

if(!$ARGV[0]) {
  print("No object provided\n");
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

$restoration_destination =  $pwd.'/'.$object.'s/'.$name.'.plx';
$file_to_restore = $pwd.'/scripts/bak/'.$object.'s/'.$name.'.plx';

if(! -e $file_to_restore) {
  print("$object $name does not exist to be restored\n");
  exit;
}

if(-e $restoration_destination) {
  print("Cannot overwrite existing $object, please remove it first");
  exit;
}

`mv $file_to_restore $restoration_destination`;
`chmod +x $restoration_destination`;

exit;
