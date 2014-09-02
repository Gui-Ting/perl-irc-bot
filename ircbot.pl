#!usr/bin/perl
use utf8;
use strict;
use Socket;
use IO::Prompter;
binmode STDIN,":utf8";
binmode STDOUT,":utf8";

my $ip_address='203.30.57.15';
my $port=6665;
my $SOCKET;
my %channels;
my %log_fh;
my $hostname="yenshine";
socket($SOCKET,PF_INET,SOCK_STREAM,getprotobyname('tcp'));

connect($SOCKET,pack_sockaddr_in($port,inet_aton($ip_address)));

binmode $SOCKET,':encoding(UTF-8)';

print "Which channel to join?(<CHANNEL>)"."\n";
chomp(my @ask_channel=<STDIN>);
$channels{$_}="#$_" for (@ask_channel);

for (sort keys %channels) {
  system"touch /home/yenshine/perl/perl-irc-bot/log/$_-log.txt" unless (-e"/home/yenshine/perl/perl-irc-bot/log/$_-log.txt");
  open $log_fh{$_},">>:encoding(UTF-8)","/home/yenshine/perl/perl-irc-bot/log/$_-log.txt";
};

$_->autoflush(1) for ($SOCKET,values %log_fh);

print $SOCKET "USER $hostname $hostname $hostname $hostname\n";

print $SOCKET "NICK yenshine-\n";

print $SOCKET "JOIN $channels{$_}\n" for (sort keys %channels);

my $data;

while ( $data=<$SOCKET>) {
  if ($data=~/^(:(?<name>.*)!)(.*)(PRIVMSG) (?<channel>#.*) (:)((?<say>.*))/ism) {
    for ( keys %channels) {
      if ($+{channel} eq $channels{$_}) {
        print {$log_fh{$_}} "$+{name} say:$+{say} at $+{channel} \n";
      };
    };
  };
  
  print $SOCKET "PONG :roddenberry.freenode.net\n" if ($data =~/(PING).*/);

  if ($data=~/(^:yenshine)(.*)(PRIVMSG) (#cmutalk) (:)(謝謝)/i) {
    print $SOCKET "PRIVMSG #cmutalk :不客氣！\n";
  } elsif  ($data=~/(^:yenshine)(.*)(PRIVMSG) (#cmutalk) (:)(.*)/si) {    
    print $SOCKET "PRIVMSG #cmutalk :yenshine 超帥\n";
  };
  
  if ($data=~/(^:haroldwu)(.*)(PRIVMSG) (#cmutalk) (:)(.*)/si) {
    print $SOCKET "PRIVMSG #cmutalk :甫哥哥,我來學你說話:$6\n";
    print $SOCKET "PRIVMSG haroldwu :甫哥哥,我來學你說話:$6\n";
  };
};

  
