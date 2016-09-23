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
my %configHash = parseConfigFile($configFileName);
foreach my $eachLog (@logList){
    my %hashInfo = parseLog($eachLog);
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
    open LOG, $logName or die "Could not read the log $logName!";
    my ($errorFile, $errorMsg);
    while(<LOG>){
        my $errorMsg;
        if(/^(\S+\.(java|xml))\s*:\s*((\d+)*)\s*:\s*error\s*:\s*(.*)/is){
            if(!exists($errorFileList{$1})){
                $errorFileList{$1}->{line}  = $3;
                $errorFileList{$1}->{msg}   = $5;
                $errorFileList{$1}->{commit} = findOwner($1);
            }
        }
    }
    print Dumper \%errorFileList;
    close LOG;
    return %errorFileList;
}

sub findOwner(){
    my ($errorFile) = @_;
    #my $filePath = $configHash->{codebase}->{path};
    my $filePath = "/data/zhongshan/test/".$errorFile;
    my $ownerInfo;
    if(-f $filePath){
        print "$filePath\n";
        return getFileInfo($filePath);
    }
    else{
        return {};
    }
}

sub getFileInfo(){
    my ($file) = @_;
    my $commitInfo;
    if($file =~ /(.*)\/(.*)/is){
        chdir($1);
        my $fileHistory = `git log -1 $2`;
        if($fileHistory =~ /commit\s+(\S+).*?Author:\s*(\S+)\s+<(\S+)>.*?Date:\s*(.*?\+\d+).*?Ticket:\s*(\S+).*?Change-Id:\s*(\S+).*?Signed-off-by:\s*(\S+).*?<(\S+)>/is){
            $commitInfo->{commitId} = $1;
            $commitInfo->{author} = $2;
            $commitInfo->{authorEmail} = $3;
            $commitInfo->{date} = $4;
            $commitInfo->{ticket} = $5;
            $commitInfo->{changeId} = $6;
            $commitInfo->{signOff} = $7;
            $commitInfo->{signOffEmail} = $8;
        }
    }
    return $commitInfo;
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
                #print "($key, $value)", "\n";
            }
        }
    }
    close(CONFIG);
}
