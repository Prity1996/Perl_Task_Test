#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use DBI;
 
my $file = $ARGV[0] or die "pass input csv file\n";
my $username = "root";
my $password = 'Welcome@123';
my $dbname="testing";
my $server="localhost";

my @fields;

my $dsn = "DBI:mysql:database=".$dbname.";host=".$server.";port=3306";
my $dbh = DBI->connect($dsn, $username, $password, { RaiseError  => 1});

$dbh->do("CREATE TABLE employee (id MEDIUMINT NOT NULL AUTO_INCREMENT, firstname VARCHAR(25), lastname VARCHAR(25), age VARCHAR(15), created_on datetime , comments VARCHAR(15),PRIMARY KEY (id))");
$dbh->do("CREATE TABLE phone (id MEDIUMINT  NOT NULL AUTO_INCREMENT, person_id INT(5), phone_number VARCHAR(25),PRIMARY KEY (id))");
 
open(my $data, '<', $file) or die "Could not open '$file' $!\n";

while (my $line = <$data>)
{
    chomp $line;
    @fields = split "," , $line;
    insertdata(@fields);
}
 
sub insertdata
{
    my @data = @_;
    my $comment=$ARGV[1]; 
    my $firstinsert = $dbh->prepare("INSERT INTO `employee` (`firstname`,`lastname`,`age`,`created_on`)  VALUES('".$data[0]."','".$data[1]."','".$data[2]."',now(),'".$comment."')");
      $firstinsert->execute() or die "Couldn't execute statement: " . $firstinsert->errstr;
      my $emp_id = $firstinsert->{mysql_insertid};

    my $secinsert = $dbh->prepare("INSERT INTO `phone` (`person_id`,`phone_number`) VALUES('".$emp_id."','".$data[3]."')");
      $secinsert->execute() or die "Couldn't execute statement: " . $secinsert->errstr;
}



