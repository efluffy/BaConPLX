#!/usr/bin/perl
use warnings;
use Cwd 'abs_path';

# Get parent directory
my $pwd = abs_path($0);
$pwd =~ s/^(.*?)\/remove.plx/$1/;
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

$file_to_remove =  $pwd.'/'.$object.'s/'.$name.'.plx';
$backup_file = $pwd.'/scripts/bak/'.$object.'s/'.$name.'.plx';

if(! -e $file_to_remove) {
  print("$object $name does not exist\n");
  exit;
}

if(-e $backup_file) {
  `rm $backup_file`;
}

`mv $file_to_remove $backup_file`;

exit;
