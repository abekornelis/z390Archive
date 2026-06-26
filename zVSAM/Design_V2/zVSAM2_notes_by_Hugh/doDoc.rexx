/* A Rexx program to generate all z390 documentation. */

/* Presumed to be running with PWD = '/Dev/zVSAM/javadoc' */

cmd = 'javadoc -private' ,
            '../../zB11/src/az390.java'         ,
            '../../zB11/src/ez390.java'         ,
            '../../zB11/src/iz390.java'         ,
            '../../zB11/src/lz390.java'         ,
            '../../zB11/src/mz390.java'         ,
            '../../zB11/src/gz390.java'         ,
            '../../zB11/src/gz390_screen.java'  ,
            '../../zB11/src/pz390.java'         ,
            '../../zB11/src/sz390.java'         ,
            '../../zB11/src/zc390.java'         ,
            '../../zB11/src/z390.java'          ,
            '../../zB11/src/MessageBox.java'    ,
            '../src/tz390.java'                 ,
            '../src/vz390.java'

Say "Issuing: [" || cmd || "]"

address command cmd
Return rc
