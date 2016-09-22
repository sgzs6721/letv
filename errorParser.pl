#!/usr/bin/perl
use strict;
use Getopt::Long; 
use Data::Dumper;
#use Smart::Comments;
use vars qw($logName $configFileName $insertDB $mail $jira);

GetOptions(
    'path=s'    => \$logName, 
    'cfg=s'     => \$configFileName,
    'db!'       => \$insertDB,
    'mail!'     => \$mail,
); 

my @logList = getLog();
if(!$configFileName) {$configFileName = "config.cfg";}
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
    my @fileList = glob "log*\.txt";
    return @fileList;
}

sub parseLog(){
    my ($logName) = @_;
    my %errorFileList;
    print $logName;
    open LOG, $logName or die "Could not read the log $logName!";
    my ($errorFile, $errorMsg);
    while(<LOG>){
        my $errorMsg;
        if(/^(\S+\.(java|xml))\s*:\s*((\d+)*)\s*:\s*error\s*:\s*(.*)/is){
            if(!exists($errorFileList{$1})){
                $errorFileList{$1}->{line}  = $3;
                $errorFileList{$1}->{msg}   = ($5);
                $errorFileList{$1}->{owner} = findOwner($1);
            }
        }
    }
    close LOG;
    print Dumper \%errorFileList;
}

sub findOwner(){
    my ($errorFile) = @_;
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
