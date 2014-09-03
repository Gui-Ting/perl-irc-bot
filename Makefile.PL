#!usr/bin/perl
use ExtUtils::MakeMaker;

WriteMakefile (
               PREREQ_PM=>{'IO::Socket::INET'=>'1.33'},
               );
