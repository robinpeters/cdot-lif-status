# lif-status

    Command line tool to display the Clustered Ontap logical interface status to know which interface/physical-port is overloaded.

## Status:
    * Work in Progress
    * Please let me know, if I can provide additional information.

##  Contacts:
    * Email  : robin dot peter at gmail dot com

## Prerequisities:
```
    * OSX [Tested]
        Perl Modules from CPAN: 
            Getopt::Long qw(:config no_ignore_case no_auto_abbrev bundling);
            use Math::Round qw(:all);
        Perl Modules from NMSDK:
        $ ls  lib/NetApp/
            DfmErrno.pm     
            NaErrno.pm
            OCUMClassicAPI.pm   
            ONTAPITestContainer.pm  
            OntapClusterAPI.pm  
            Test.pm
            NaElement.pm        
            NaServer.pm     
            OCUMAPI.pm      
            ONTAPILogParser.pm  
            Ontap7ModeAPI.pm    
            SdkEnv.pm

    * Linux [Not Tested Yet]
```

## Installation:
```
$ git clone https://github.com/robinpeters/cdot-lif-status.git
$ cd Red8-Realize/
```

## Usage:
```
$ ./lifstat.pl -V
lifstat 1.1.0 : Tue Jun 13 11:08:24 PDT 2017 

$ ./lifstat.pl -h
Usage :: 
  -c|--cluster : Cluster Name to get Logical Interface Status. 
  -n|--node       : Node Name [To limit the lif stats to node level]. 
  -u|--username   : Username to connect to cluster.       Example : -u admin 
  -p|--passwd     : Password for username.                Example : -p netapp123 
  -v|--vserver    : Vserver Name [To limit the lif stats to vserver level]. 
  -i|--interval   : The Interval in seconds between the stats. 
  -h|--help       : Print this Help and Exit! 
  -V|--version    : Print the Version of this Script and Exit! 
         Node     : System node name. 
         UUID     : UUID for the logical interface (LIF) instance. 
         R-Data   : Number of bytes received per second. 
         R-Err    : Number of received Errors per second. 
         R-Pkts   : Number of packets received per second. 
         S-Data   : Number of bytes sent per second. 
         S-Err    : Number of sent errors per second. 
         S-Pkts   : Number of packets sent per second. 
         LIF-Name : Name of the logical interface (LIF) instance.

```

## Example:
```
$ ./lifstat.pl 
Option c required 
Option u required 
Option p required 
Usage :: 
  -c|--cluster : Cluster Name to get Logical Interface Status. 
  -n|--node       : Node Name [To limit the lif stats to node level]. 
  -u|--username   : Username to connect to cluster.       Example : -u admin 
  -p|--passwd     : Password for username.                Example : -p netapp123 
  -v|--vserver    : Vserver Name [To limit the lif stats to vserver level]. 
  -i|--interval   : The Interval in seconds between the stats. 
  -h|--help       : Print this Help and Exit! 
  -V|--version    : Print the Version of this Script and Exit!


$ ./lifstat.pl -c 10.10.10.10 -u username -p password 
Node             UUID        R-Data R-Err   R-Pkts       S-Data S-Err   S-Pkts  LIF-Name             
node-01          1065       1748060     0      187            0     0        0  nfs_lif3             
node-01          1024           976     0        5          564     0        5  node-01_clus1     
node-02          1014           564     0        5          976     0        5  node-02_clus2     
node-01          1049           492     0        4          392     0        4  node-01_clus3     
node-02          1051           392     0        4          492     0        4  node-02_clus3     
node-02          1066           220     0        1            0     0        0  nfs_lif4             
node-02          1013           128     0        2          128     0        2  node-02_clus1     
node-01          1023           128     0        2          128     0        2  node-01_clus2     
node-02          1064             0     0        0            0     0        0  nfs_lif4             
node-01          1045             0     0        0            0     0        0  iscsi_lif2           
node-01          1026             0     0        0            0     0        0  node-01_mgmt1     
node-02          1047             0     0        0            0     0        0  iscsi_lif4           
node-02          1033             0     0        0            0     0        0  DFNAS02DR_nfs_lif2   
node-01          1038             0     0        0            0     0        0  cifs_lif1        
node-01          1032             0     0        0            0     0        0  DFNAS02DR_nfs_lif1   
node-02          1058             0     0        0            0     0        0  smb3cifs_lif02       
node-01          1057             0     0        0            0     0        0  smb3cifs_lif01       
node-01          1063             0     0        0            0     0        0  nfs_lif3             
node-02          1056             0     0        0            0     0        0  node-02_nfs_lif_1 
node-01          1053             0     0        0            0     0        0  node-01_icl1      
node-01          1048             0     0        0            0     0        0  iscsi-mgmt       
node-02          1035             0     0        0            0     0        0  lif2         
node-02          1039             0     0        0            0     0        0  cifs_lif2        
node-01          1034             0     0        0            0     0        0  lif1         
node-02          1046             0     0        0            0     0        0  iscsi_lif3           
node-01          1025             0     0        0            0     0        0  cluster_mgmt         
node-02          1027             0     0        0            0     0        0  node-02_mgmt1     
node-02          1054             0     0        0            0     0        0  node-02_icl1      
node-01          1059             0     0        0            0     0        0  smb3cifs_mgmt        
node-01          1062             0     0        0            0     0        0  coecifs1             
node-01          1044             0     0        0            0     0        0  iscsi_lif1           
node-01          1052             0     0        0            0     0        0  svm2_lif1            
node-01          1050             0     0        0            0     0        0  svm1_lif1            
node-02          1055             0     0        0            0     0        0  nfs_lif_1 
^C
....
....
```

## History:

    TODO: Write History

## Credits:

    TODO: Write Credits

## License:

    TODO: Write License

## Authors:
    
    TODO: Write Authors

## EOF.
