#!/usr/bin/perl
use strict;
use Getopt::Long; 
#use Smart::Comments;
use vars qw($logName $configFileName $insertDB $mail $jira);

GetOptions(
    'path=s'    => \$logName, 
    'cfg=s'     => \$configFileName,
    'db!'       => \$insertDB,
    'mail!'     => \$mail,
); 

my @logList = getLog();
foreach my $eachLog (@logList){
    my %hashInfo = parseLog($eachLog);
    my %configHash = parseConfigFile($configFileName);
    if($insertDB){insertDatabase(\%hashInfo);}
    if($jira){sendIssue(\%hashInfo);}
    if($mail){sendEmail(\%hashInfo);}
}

sub getLog(){
    if($logName){ 
        return ($logName);
    }
    my @fileList = glob "*\.cfg";
    return @fileList;
}

sub parseLog(){
    my ($logName) = @_;
    
}

sub insertDatabase(){
    my ($info) = @_;
    
}

sub sendEmail(){
    my ($info) = @_;
    
}

sub parseConfigFile(){
    my ($cfgFile) = @_;
    my ($configLine, $key, $value);
    my $configHash;
    open (CONFIG, "$cfgFile") or die "ERROR: Config file not found : $cfgFile";
    while (<CONFIG>) 
    {
        $configLine=$_;
        chomp $configLine;
        $configLine =~ s/^\s*//;
        $configLine =~ s/\s*$//;
        if ( ($configLine !~ /^#/) && ($configLine ne "") )
        {
            if ($configLine =~ /\[\S+\]/) {}
                #TODO
            else
            {
                ($key, $value) = split (/=/, $configLine);
                $key =~ s/^\s*//;
                $key =~ s/\s*$//;
                $value =~ s/^\s*//;
                $value =~ s/\s*$//;
                print "($key, $value)", "\n";
            }
        }
    }
    close(CONFIG);
}
