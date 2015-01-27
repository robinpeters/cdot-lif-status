#!/usr/bin/perl
#
# Written By    : <Robin.Peter@gmail.com>
# Created On    : Mon Sep  8 12:05:41 PDT 2014
# Modified On	: Mon Sep  8 12:05:41 PDT 2014
# Program Name  : lifstat.pl
# Version       : 1.0.0
#
#------------------------------------------------------------------#
use strict;
use Getopt::Long qw(:config no_ignore_case no_auto_abbrev bundling);
use lib "/lib/NetApp";
use Math::Round qw(:all);
use NaServer;
use NaElement;
#------------------------------------------------------------------#
my $interval = 2;
my ($filer, $node, $vserver, $help, $version);
GetOptions("f|c|cluster=s"      => \$filer,
           "n|node=s"           => \$node,
           "v|vserver=s"        => \$vserver,
           "i|interval=i"       => \$interval,
           "h|help"             => \$help,
           "V|version"          => \$version)
    or die("Error In Command Line Arguments!\n", help());
#------------------------------------------------------------------#
sub help {
    print "Usage :: \n";
    print "  -f|-c|--cluster : Cluster Name to get Logical Interface Status. \n";
    print "  -n|--node       : Node Name [To limit the lif stats to node level]. \n";
    print "  -v|--vserver    : Vserver Name [To limit the lif stats to vserver level]. \n";
    print "  -i|--interval   : The Interval in seconds between the stats. \n";
    print "  -h|--help       : Print this Help and Exit! \n";
    print "  -V|--version    : Print the Version of this Script and Exit! \n";
    if ($help) {
        print "         Node     : System node name. \n";
        print "         UUID     : UUID for the logical interface (LIF) instance. \n";
        print "         R-Data   : Number of bytes received per second. \n";
        print "         R-Err    : Number of received Errors per second. \n";
        print "         R-Pkts   : Number of packets received per second. \n";
        print "         S-Data   : Number of bytes sent per second. \n";
        print "         S-Err    : Number of sent errors per second. \n";
        print "         S-Pkts   : Number of packets sent per second. \n";
        print "         LIF-Name : Name of the logical interface (LIF) instance. \n";
    }
    exit 0;
}

if ($help eq '1'){
    help();
} elsif ($version eq '1'){
    print "lifstat 1.0.0 : Mon Sep  8 12:05:41 PDT 2014 \n";
    exit 0;
} elsif ($filer) {
    lifstatloop($filer);
} else {
    help();
}
#------------------------------------------------------------------#
sub connect_netapp {
    my $filer   = shift;
    my $fi1er   = NaServer->new($filer, 1, 20);
    if ( !defined ($filer) ) {
        my $outa    = $filer->set_server_type("FILER");
        my $reason  = $outa->results_reason();
        print "Unable to set server type 'FILER'. $reason\n";
        exit 2;
	}
    if ( !defined ($filer) ) {
        my $outb    = $filer->set_style("HOSTS");
        my $reason  = $outb->results_reason();
        print "Unable to set auth style 'HOSTS'. $reason\n";
        exit 2;
    }
    if ( !defined ($filer) ) {
        my $outc    = $filer->set_transport_type("HTTP");
        my $reason  = $outc->results_reason();
        print "Unable to set transport type 'HTTP'. $reason\n";
        exit 2;
    }
    if ( !defined ($filer) ) {
        my $outd    = $filer->set_timeout(60);
        my $reason  = $outd->results_reason();
        print "Unable to set connection timeout '60'. $reason\n";
        exit 2;
    }
    return $fi1er;
}
#------------------------------------------------------------------#
sub lifstatloop {
    my $filer = shift;
    my (%lifdataA, %lifdataB);
    while ($filer) {
        %lifdataA = getlifstat($filer);
        if (!%lifdataB) {
            %lifdataB = %lifdataA;
        } else {
            my (%data);
            foreach my $key (keys %lifdataA) {
                my (@info, $name, $uuid, $node, $rcdt, $rcer, $rcpk, $sndt, $sner, $snpk, $time);
                $time = ( $lifdataA{$key}[11] -  $lifdataB{$key}[11] );
                $name = $lifdataA{$key}[1];
                $uuid = $lifdataA{$key}[2];
                $node = $lifdataA{$key}[3];
                $rcdt = eval{int(($lifdataA{$key}[4] - $lifdataB{$key}[4]) / $time)};
                $rcer = $lifdataA{$key}[5];
                $rcpk = eval{int(($lifdataA{$key}[6] - $lifdataB{$key}[6]) / $time)};
                $sndt = eval{int(($lifdataA{$key}[7] - $lifdataB{$key}[7]) / $time)};
                $sner = $lifdataA{$key}[8];
                $snpk = eval{int(($lifdataA{$key}[9] - $lifdataB{$key}[9]) / $time)};
                if ($uuid) {
                    push @info, $name, $uuid, $node, $rcdt, $rcer, $rcpk, $sndt, $sner, $snpk;
                    $data{$uuid} = \@info;
                }
            }
            system("clear");
            printf "%-8s  %5s  %12s %5s %8s %12s %5s %8s  %-20s \n",
                "Node", "UUID", "R-Data", "R-Err", "R-Pkts", "S-Data", "S-Err", "S-Pkts", "LIF-Name";
            foreach my $i (sort {$data{$b}->[3] <=> $data{$a}->[3]} keys %data) {
                printf "%-8s  %5s  %12s %5s %8s %12s %5s %8s  %-20s \n",
                        $data{$i}[2], $data{$i}[1], $data{$i}[3], $data{$i}[4], $data{$i}[5],
                        $data{$i}[6], $data{$i}[7], $data{$i}[8], $data{$i}[0];
            }
            %lifdataB = %lifdataA;
            sleep($interval);
        }
    }
}
#------------------------------------------------------------------#
sub getliflist {
    my $filer = shift;
	
	my $api = new NaElement('perf-object-instance-list-info-iter');
        $api->child_add_string('objectname','lif');
        $api->child_add_string('max-records','100000');
        if ($vserver) {
            $api->child_add_string('filter-data', "vserver_name=$vserver");
        } elsif ($node) {
            $api->child_add_string('filter-data', "node_name=$node");
        }
    
    my $ss = connect_netapp($filer);
	my $out = $ss->invoke_elem($api);
    if ($out->results_status() eq "failed"){
        print ((caller(0))[3], " ", $out->results_reason(), "\n");
    }

    my %liflist;
	my $instances = $out->child_get("attributes-list");
	my @instances = $instances->children_get();
	for my $instance (@instances) {
		my $lifname = $instance->child_get_string("uuid");
		$liflist{$lifname}++;
	}
    return %liflist;
}
#------------------------------------------------------------------# 
sub getlifstat{
    my $filer = shift;
    my %liflist = getliflist($filer);

	my $api = new NaElement('perf-object-get-instances');
        $api->child_add_string('objectname','lif');
        my $apiA = new NaElement('instance-uuids');
        for my $lif (keys %liflist) {
            $apiA->child_add_string("instance-uuid",$lif);
        }
	$api->child_add($apiA);    

    my $ss = connect_netapp($filer);
	my $out = $ss->invoke_elem($api);
	if ($out->results_status() eq "failed"){
        print ((caller(0))[3], " ", $out->results_reason(), "\n");
    }
    
    my $timestamp = $out->child_get_string("timestamp");
	my @instances = $out->child_get("instances")->children_get();
    my %lifdata;
	for my $instance (@instances) {
        my $instname = $instance->child_get_string("name");
        my $uuid     = $instance->child_get_string("uuid");
		my $counters = $instance->child_get("counters");
		my @counters = $counters->children_get();
        my (@lifinfo, $insname, $insuuid, $nodename, $recdata, $recerr, $recpkt, $sntdata, $snterr, $sntpkt, $vserver);
        for my $counter (@counters) {
            my $name = $counter->child_get_string("name");
			my $value = $counter->child_get_string("value");
            if ($name eq "instance_name") {
                $insname = $value;
            } elsif ($name eq "instance_uuid") {
                $insuuid = $value;
            } elsif ($name eq "node_name") {
                $nodename = $value;
            } elsif ($name eq "recv_data") {
                $recdata = $value;
            } elsif ($name eq "recv_errors") {
                $recerr = $value;
            } elsif ($name eq "recv_packet") {
                $recpkt = $value;
            } elsif ($name eq "sent_data") {
                $sntdata = $value;
            } elsif ($name eq "sent_errors") {
                $snterr = $value;
            } elsif ($name eq "sent_packet") {
                $sntpkt = $value;
            } elsif ($name eq "vserver_name") {
                $vserver = $value;
            } 
        }
        push @lifinfo, $instname, $insname, $insuuid, $nodename, $recdata, $recerr, $recpkt, $sntdata, $snterr, $sntpkt, $vserver, $timestamp;
        $lifdata{$insuuid} = \@lifinfo;
	}
    return %lifdata;
}
#------------------------------------------------------------------#
# EOF
