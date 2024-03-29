#!/usr/bin/perl
use strict;
use utf8;
use IO::Socket::SSL;
binmode STDIN,':utf8';
binmode STDOUT,':utf8';


my $client_socket = IO::Socket::SSL->new(
                                          PeerAddr=>'203.30.57.15',
                                          PeerPort=>'7000',
                                          Proto=>'tcp',
                                        );
my %channels;
my %log_fh;
print "Which channel to join?(<CHANNEL>)"."\n";
chomp(my @ask_channel=<STDIN>);
$channels{$_}="#$_" for (@ask_channel);

for (sort keys %channels) {
  system"touch ./$_-log.txt" unless (-e"./$_-log.txt");
  open $log_fh{$_},">>:encoding(UTF-8)","./$_-log.txt";
};

$_->autoflush(1) for (values %log_fh);
my $hostname="yenshine";
print $client_socket "USER $hostname $hostname $hostname $hostname\n";

print $client_socket "NICK yenshine-\n";

print $client_socket "JOIN $channels{$_}\n" for (sort keys %channels);
my $socket_info;
while ($socket_info = <$client_socket>) {
  print $socket_info;
  print $client_socket "PONG :roddenberry.freenode.net\n" if ($socket_info =~/(PING).*/);
  
  if ($socket_info =~/^(:(?<name>.*)!)(.*)(PRIVMSG) (?<channel>#.*) (:)((?<say>.*))/ism) {
    for (keys %channels) {
      if ($channels{$_} eq $+{channel}) {
        print {$log_fh{$_}} "$+{name} : $+{say}\n";
      };
    };
  };
};

