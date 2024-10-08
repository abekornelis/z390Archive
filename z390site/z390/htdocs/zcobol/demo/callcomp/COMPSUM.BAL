*    ZCOBOL PGM='zcobol\demo\callcomp\COMPSUM' VER=V1.5.06 05/22/12 08:X
               31:23 
*    ZCOBOL OPTIONS=() 
         COPY  COMPSUM_ZC_LABELS.CPY
*        IDENTIFICATION DIVISION.
*        PROGRAM-ID.    COMPSUM
         PRINT NOLIST,NOGEN,NOLISTUSE    SET LIST OPTION FOR INTERNAL CX
               ODE
COMPSUM  CSECT ,                CSECT WITH PROCEDURE CODE AND WS
         USING *,ZC_R15
         STM   14,12,12+4*(14-14)(13)
         CNOP  4,8             FORCE ZC390PVT TO DOUBLEWORD BOUNDARY
         BRAS  ZC_R8,ZC_LOAD
         USING *,ZC_R8            BASE FOR LOAD AND CICS V5 USE
*
*  THESE FIELDS MUST BE KEPT IN SYNC WITH zcobol\ZC390PVT.CPY
*
         DC    CL8'COMPSUM'    PVTPGM   ZCOBOL PGM NAME
         DC    CL8'05/22/12'   PVTDATE  ZCOBOL COMPILE DATE
         DC    CL8'08.31'   PVTTIME  ZCOBOL COMPILE TIME
         DC    CL8'V1.5.06'    PVTVER   ZCOBOL COMPILER VERSION
         DC    C'0'     PVTCICS  ZCOBOL EXEC CICS PGM
         DC    C'1'   PVTEXTND ZCOBOL EXTENDED PRECISION
         DC    C'0'    PVTTRUNC ZCOBOL TRUNCATE TO PICTURE
         DC    C'1'      PVTR64   ZCOBOL USE 64 BIT REGISTERS
         DC    H'80' MAX DISPLAY LINE LEN  RPI 1118
         DS    XL10            RESERVED
ZC_LOAD  DS    0H
         LA    0,=CL8'ZC390LIB'
         SR    15,15 USE DEFAULT SYS390 SEARCH
         SVC   8 LOAD R0=A(NAME) R15=DDNAME/DSNAME ADDR OR 0
         LTR   ZC_R15,ZC_R15
         JZ    ZC_LOAD_OK
         BRAS  1,*+(WTO#0009_EOT-*+1)/2*2
         DC    AL2(WTO#0009_EOT-*,0),C'ZC390LIB NOT FOUND'
WTO#0009_EOT     EQU *
         SVC   35
         LA  ZC_R15,16
         SVC 3      EXIT TO CALLER WITH RC=16
ZC_LOAD_OK DS  0H
         LR    ZC_R9,ZC_R0
         USING ZC390CVT,ZC_R9    R9=CVT
         CLC   ZCVT_ID,=C'ZCVT'              CHECK ZCVT ID AND LENGTH
         JNE   ZC_VER_ERR                    IN ZC390LIB.390 MATCH
         CLC   ZCVT_LEN,=A(ZCVT_END-ZCVT_ID) ZCOBOL PGM COMPILED ID/LEN
         BNE   ZC_VER_ERR
         L     ZC_R15,ZCVT_ZC390NUC
         BASR  ZC_R14,ZC_R15 CALL ZC390NUC TO VERIFY VER, OPTIONS
         J     ZC_VER_OK
ZC_VER_ERR DS 0H
         BRAS  1,*+(WTO#0010_EOT-*+1)/2*2
         DC    AL2(WTO#0010_EOT-*,0),C'ZC390LIB ZCVT VERIFY ERROR'
WTO#0010_EOT     EQU *
         SVC   35
         LA  ZC_R15,16
         SVC 3      EXIT TO CALLER WITH RC=16
         LTORG 
         PUSH  PRINT,NOPRINT
         PRINT OFF,NOPRINT
ZC_R0    EQU   0
ZC_R1    EQU   1
ZC_R2    EQU   2
ZC_R3    EQU   3
ZC_R4    EQU   4
ZC_R5    EQU   5
ZC_R6    EQU   6
ZC_R7    EQU   7
ZC_R8    EQU   8
ZC_R9    EQU   9
ZC_R10   EQU  10
ZC_R11   EQU  11
ZC_R12   EQU  12
ZC_R13   EQU  13
ZC_R14   EQU  14
ZC_R15   EQU  15
ZC_F0    EQU   0
ZC_F1    EQU   1
ZC_F2    EQU   2
ZC_F3    EQU   3
ZC_F4    EQU   4
ZC_F5    EQU   5
ZC_F6    EQU   6
ZC_F7    EQU   7
ZC_F8    EQU   8
ZC_F9    EQU   9
ZC_F10   EQU  10
ZC_F11   EQU  11
ZC_F12   EQU  12
ZC_F13   EQU  13
ZC_F14   EQU  14
ZC_F15   EQU  15
ZC_H     EQU   2   HIGH
ZC_L     EQU   4   LOW
ZC_E     EQU   8   EQUAL
ZC_NH    EQU   13  NOT HIGHT
ZC_NL    EQU   11  NOT LOW
ZC_NE    EQU   7   NOT EQUAL
ZC_O     EQU   1   OVERFLOW
ZC_P     EQU   2   POSITIVE
ZC_M     EQU   4   MINUS
ZC_Z     EQU   8   ZERO
ZC_NP    EQU   13  NOT POSITIVE
ZC_NM    EQU   11  NOT MINUS
ZC_NZ    EQU   7   NOT ZERO
ZC_NO    EQU   14  NOT OVERFLOW
ZC_EQ    EQU   8   EQUAL
ZC_GT    EQU   2   GREATER THAN
ZC_LT    EQU   4   LESS    THAN
ZC_GE    EQU   11  GREATER THAN OR EQUAL
ZC_LE    EQU   13  LESS    THAN OR EQUAL
         POP   PRINT,NOPRINT
PFPO_TEST    EQU  X'80' PFPO TEST IF VALID OPCODE (NOT SUPPORTED YET)
PFPO_RADIX   EQU  1 PFPO OPCODE - CONVERT FROM ONE RADIX TO ANOTHER
PFPO_RND     EQU  0 PFOP ROUNDING OPTION (ONLY DEFAULT ALLOWED)
PFPO_TYPE_EH EQU  0 EH HFP SHORT     32 BITS 7  DIGITS
PFPO_TYPE_DH EQU  1 ED HFP LONG      64 BITS 15 DIGITS
PFPO_TYPE_LH EQU  2 EL HFP EXTENDED 128 BITS 30 DIGITS
PFPO_TYPE_EB EQU  5 EB BFP SHORT     32 BITS 7  DIGITS
PFPO_TYPE_DB EQU  6 DB BFP LONG      64 BITS 16 DIGITS
PFPO_TYPE_LB EQU  7 LB BFP EXTENDED 128 BITS 34 DIGITS
PFPO_TYPE_ED EQU  8 ED DFP SHORT     32 BITS 7  DIGITS
PFPO_TYPE_DD EQU  9 DD DFP LONG      64 BITS 16 DIGITS
PFPO_TYPE_LD EQU 10 LD DFP EXTENDED 128 BITS 34 DIGITS
ZC_VER_OK DS   0H
         L     ZC_R2,24(ZC_R13) SET ZC_R2=PARMLIST ADDRESS AFTER LOAD
         LARL  ZC_R1,ZC_WS     ZC_R2=A(WORKING STORAGE WITH SAVEAREA)
         ST    ZC_R1,8(ZC_R13) FORWARD  SAVE CHAIN
         ST    ZC_R13,4(ZC_R1) BACKWARD SAVE CHAIN
         LR    ZC_R13,ZC_R1    LINK SAVE AREA IN ZC390CVT
         USING ZC_WS,ZC_R13    BASE FOR ZCOBOL WS (SEE GEN_SYM_RX.MAC)
         ST    ZC_R13,ZC_WS_START  SAVE ADDR WS IN WS PREFIX
         LARL  ZC_R0,ZC_WS_END
         SR    ZC_R0,ZC_R13
         ST    ZC_R0,ZC_WS_LEN     SAVE LENGTH OF WS IN WS PREFIX
         DROP  ZC_R15              RPI 1042
ZC_WSLOC LOCTR 
ZC_WS    DS    0D           START WORKING STORAGE
ZC390CVT DSECT 
ZCVT_ID            DC    C'ZCVT'             ZCVT ID  VERIFIED BY ZCOB
ZCVT_LEN           DC    A(ZCVT_END-ZCVT_ID) ZCVT LEN VERIFIED BY ZCOB
ZCVT_VER           DC    CL8'V1.5.06'    ZCVT VER VERIFIED BY ZC390NUC
ZCVT_ZC390NUC  DC V(ZC390NUC)      MODULE  SYSTEM ROUTINE MODULE INIT
ZCVT_CALL           DC V(CALL)       ENTRY R0=A(PGM),R1=A(PARMLIST)
ZCVT_CMP64R32       DC V(CMP64R32)   ENTRY COMPARE R0-1=FLD1 R2-3=FLD2
ZCVT_CVTLBTQ        DC V(CVTLBTQ)    ENTRY CVT LB IN F4-6 TO Q IN R0-1
ZCVT_CVTLDTP        DC V(CVTLDTP)    ENTRY CVT LD IN F0-2 TO PL31 R0-1
ZCVT_CVTQTLB        DC V(CVTQTLB)    ENTRY CVT Q IN R0-1 TO LB IN F4-6
ZCVT_DIV64R32       DC V(DIV64R32)   ENTRY DIVIDE R0-1=N64, R2-3=MAX64
ZCVT_DIVQ128        DC V(DIVQ128)    ENTRY DIVIDE Q128 R0-R1 BY R2-R3
ZCVT_GOBACK         DC V(GOBACK)     ENTRY R1=RC
ZCVT_MPYQ128        DC V(MPYQ128)    ENTRY MULTIPLY Q128 R0-R1 BY R2-R3
ZCVT_OSE64R32       DC V(OSE64R32)   ENTRY ON SIZE ERR R0-1=N, R2-3=MAX
ZCVT_PERFORM        DC V(PERFORM)    ENTRY R14=PGTAR,R0=PGEXT,R1=PMRET
ZCVT_PMCHECK        DC V(PMCHECK)    ENTRY R14=RETURN TO NEXT INSTR.
ZCVT_ROUNDF         DC V(ROUNDF)     ENTRY R0=REM,R1=QUO,R2=DIVISOR
ZCVT_STACKORG       DC V(STACKORG)   ENTRY PERFORM STACK ORIGIN
ZCVT_STACKPTR       DC V(STACKPTR)   ENTRY CUR ENTRY A(PG_END+4,RET)
ZCVT_STACKEND       DC V(STACKEND)   ENTRY PERFORM STACK END
ZCVT_STOPRUN        DC V(STOPRUN)    ENTRY R1=RC
ZCVT_TALPHAX        DC V(TALPHAX)    ENTRY TEST ALPHABETIC X
ZCVT_TNUMP          DC V(TNUMP)      ENTRY TEST NUMERIC P
ZCVT_TNUMX          DC V(TNUMX)      ENTRY TEST NUMERIC X
ZCVT_TNUMZ          DC V(TNUMZ)      ENTRY TEST NUMERIC Z
*
* ADDITIONAL SEPARATE MODULES LINKED WITH Z390NUC IN ZC390LIB.390
*
ZCVT_ABORT     DC V(ABORT)         MODULE  R1=ABORT ERROR MSG #
ZCVT_ABORT_ALTER   EQU    1 ABORT ALTER DUE TO BRC NOT FOUND AT TARGET
ZCVT_ABORT_CALL    EQU    2 ABORT DYNAMIC CALL - PGM NOT FOUND
ZCVT_ABORT_DISPLAY EQU    3 ABORT DISPLAY DUE TO BUFFER EXCEEDED
ZCVT_ABORT_OPEN    EQU    4 ABORT OPEN  INVALID DCB
ZCVT_ABORT_STACK   EQU    6 ABORT PEROFRM STACK OVERFLOW
ZCVT_ABORT_VERSION EQU    7 ABORT ZC390NUC INIT ZCOBOL VERSION ERROR
ZCVT_ABORT_INT128  EQU    8 ABORT INTEGER 128 CONVERSION OVERFLO
ZCVT_ABORT_DIVQ    EQU    9 ABORT DIVIDE Q IF DIVISOR 0 OR > 2**63
ZCVT_ABORT_CICS    EQU   10 ABORT THIS PGM REQUIRES EXEC CICS TRANS MGR
ZCVT_ABORT_ACCEPT  EQU   11 ABORT ACCEPT EOF
ZCVT_ABORT_MAXERR  EQU   11 ABORT MAX ERROR CODE
ZCVT_ACCEPT    DC V(ACCEPT)        MODULE  R1=A(TYPE,FLD_ADD,FLD_LEN)
ZCVT_ACCEPT_DEFAULT EQU   1 INPUT DEFAULT DDNAME=SYSIN
ZCVT_ACCEPT_CONSOLE EQU   2 INPUT VIA WTOR FROM CONSOLE
ZCVT_ACCEPT_DDNAME  EQU   3 INPUT FROM DDNAME WITH DDNAME ADDR IN R3
ZCVT_ACCEPT_DATE    EQU   4 RETURN DAY OF WEEK PIC 9(8) MMDDYYYY
ZCVT_ACCEPT_TIME    EQU   5 RETURN DAY OF WEEK PIC 9(8) HHMMSSTH
ZCVT_ACCEPT_DOW     EQU   6 RETURN DAY OF WEEK PIC 9 1-7
ZCVT_DISPLAY   DC V(DISPLAY)       MODULE  R1=A(ADDR,LEN,TYPE)
ZCVT_INSPECT   DC V(INSPECT)       MODULE  R0=TYPE,R1=PARMLIST
ZCVT_TALLYING      EQU   0 INSPECT TALLYING
ZCVT_REPLACING     EQU   4 INSPECT REPLACING
ZCVT_CONVERTING    EQU   8 INSPECT CONVERTING
*
* SHARED DATA AREAS
*
ZCVT_PVTMAXDL  DS H          MAXIMUM DISPLAY LINE LENGTH  RPI 1118
               DS 0D
ZCVT_ZERO      DC XL16'00'   BINARY ZEROS
ZCVT_HIGH_VALUES DC 0XL16,16X'FF' BINARY FF'S     RPI 1181
ZCVT_PWORK     DS PL8        CVD/CVB WORK
ZCVT_PWORK1    DS PL16       DIV DIVIDEND, CVDG/CVBG WORK
ZCVT_PWORK2    DS PL16       DIV DIVISOR
ZCVT_PWORK3    DS PL16       DIV QUOTIENT
ZCVT_PWORK4    DS PL16       DIV REMAINDER
ZCVT_NDDX      DS XL16       DIV DIVIDEND HOLD AREA
ZCVT_WORKAREA  DS XL256      GEN_INSPECT PARMS, GEN_EDIT WORK, ETC.
*
* END OF ZC390CVT
*
ZCVT_END   EQU   *
ZC390PVT DSECT 
PVTPGM   DS    CL8  ZCOBOL PGM NAME
PVTDATE  DS    CL8  ZCOBOL COMPILE DATE
PVTTIME  DS    CL8  ZCOBOL COMPILE TIME
PVTVER   DS    CL8  ZCOBOL COMPILER VERSION
PVTCICS  DS    C    ZCOBOL EXEC CICS PGM
PVTEXTND DS    C    ZCOBOL EXTENDED PRECISION
PVTTRUNC DS    C    ZCOBOL TRUNCATE TO PICTURE
PVTR64   DS    C    ZCOBOL USE 64 BIT REGISTERS
PVTMAXDL DS    H    ZCOBOL MAX DISPLAY LINE LENGTH
         DS    XL10 RESERVED
ZC_WSLOC LOCTR              CONTINUE WS FOR FD AND DATA
*        AUTHOR.        DON HIGGINS.
*        DATE-WRITTEN.  05/12/12.
*      * SUBROUTINE CALLED TO ADD 15 DATA FIELDS AND RETURN SUM.       
*        ENVIRONMENT DIVISION.
*        DATA DIVISION.
         PRINT DATA
*        LINKAGE SECTION.
*        01 ZDATA.
*           05 EH1 FLOAT-HEX-7.
*           05 DH1 FLOAT-HEX-15.
*           05 LH1 FLOAT-HEX-30.
*           05 EB1 FLOAT-BINARY-7.
*           05 DB1 FLOAT-BINARY-16.
*           05 LB1 FLOAT-BINARY-34.
*           05 ED1 FLOAT-DECIMAL-7.
*           05 DD1 FLOAT-DECIMAL-16.
*           05 LD1 FLOAT-DECIMAL-34.
*           05 H1      COMP PIC S9(3)V9.
*           05 F1      COMP PIC S9(7)V99.
*           05 G1      COMP PIC S9(15)V999.
*           05 Q1      COMP PIC S9(35)V9999.
*           05 P1      COMP-3 PIC S9(26)V9(5).
*           05 Z1             PIC S9(25)V9(6).
*           05 PSUM    COMP-3 PIC S9(4)V9.
*        PROCEDURE DIVISION USING ZDATA.
*ZC   PROCEDURE DIVISION,USING,ZDATA
         PRINT LIST,GEN,LISTUSE TURN PRINT LISTING ON FOR USER CODE GEN
COMPSUM  CSECT                SWITCH TO PROCEDURE CODE AHEAD OF WS
         L     ZC_R0,0(ZC_R2)          LOAD PARM ADDR FROM PARMLIST
         ST    ZC_R0,ZC_ZDATA_PTR STORE PARM POINTER
*            COMPUTE PSUM = EH1+DH1+LH1
*                          +EB1+DB1+LB1
*                          +ED1+DD1+LD1
*                          +H1+F1+G1
*                          +Q1+P1+Z1           .
*ZC     27         COMPUTE PSUM,=,EH1,+,DH1,+,LH1,+,EB1,+,DB1,+,LB1,+,EX
               D1,+,DD1,+,LD1,+,H1,+,F1,+,G1,+,Q1,+,P1,+,Z1
         L     ZC_R4,ZC_ZDATA_PTR
         USING ZDATA_DSECT,ZC_R4
         MNOTE 'ZC_CALC PARMS=PSUM,=,EH1,+,DH1,+,LH1,+,EB1,+,DB1,+,LB1,X
               +,ED1,+,DD1,+,LD1,+,H1,+,F1,+,G1,+,Q1,+,P1,+,Z1'
         MNOTE 'ZC_CALC   MOVE TMP-1,9,16,0 EH1,1,4,0'
         LE    ZC_F4,EH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EH,PFPO_RNDX
               )
         PFPO 
         STD   0,ZCVT_WORKAREA+0
         STD   2,8+ZCVT_WORKAREA+0
         MNOTE 'ZC_CALC   ADD TMP-1,9,16,0 DH1,2,8,0'
         LD    ZC_F4,DH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,ZCVT_WORKAREA+0
         LD    ZC_F3,8+ZCVT_WORKAREA+0
         AXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,ZCVT_WORKAREA+0
         STD   ZC_F2,8+ZCVT_WORKAREA+0
         MNOTE 'ZC_CALC   MOVE TMP-2,9,16,0 TMP-1,9,16,0'
         MVC   ZCVT_WORKAREA+16(16),16-16+ZCVT_WORKAREA+0 ALN RIGHT 9ZP
         MNOTE 'ZC_CALC   ADD TMP-2,9,16,0 LH1,3,16,0'
         LD    ZC_F4,LH1
         LD    ZC_F6,8+LH1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LH,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,ZCVT_WORKAREA+16
         LD    ZC_F3,8+ZCVT_WORKAREA+16
         AXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,ZCVT_WORKAREA+16
         STD   ZC_F2,8+ZCVT_WORKAREA+16
         MNOTE 'ZC_CALC   MOVE TMP-1,9,16,0 TMP-2,9,16,0'
         MVC   ZCVT_WORKAREA+0(16),16-16+ZCVT_WORKAREA+16 ALN RIGHT 9ZP
         MNOTE 'ZC_CALC   ADD TMP-1,9,16,0 EB1,4,4,0'
         LE    ZC_F4,EB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_EB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,ZCVT_WORKAREA+0
         LD    ZC_F3,8+ZCVT_WORKAREA+0
         AXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,ZCVT_WORKAREA+0
         STD   ZC_F2,8+ZCVT_WORKAREA+0
         MNOTE 'ZC_CALC   MOVE TMP-2,9,16,0 TMP-1,9,16,0'
         MVC   ZCVT_WORKAREA+16(16),16-16+ZCVT_WORKAREA+0 ALN RIGHT 9ZP
         MNOTE 'ZC_CALC   ADD TMP-2,9,16,0 DB1,5,8,0'
         LD    ZC_F4,DB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,ZCVT_WORKAREA+16
         LD    ZC_F3,8+ZCVT_WORKAREA+16
         AXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,ZCVT_WORKAREA+16
         STD   ZC_F2,8+ZCVT_WORKAREA+16
         MNOTE 'ZC_CALC   MOVE TMP-1,9,16,0 TMP-2,9,16,0'
         MVC   ZCVT_WORKAREA+0(16),16-16+ZCVT_WORKAREA+16 ALN RIGHT 9ZP
         MNOTE 'ZC_CALC   ADD TMP-1,9,16,0 LB1,6,16,0'
         LD    ZC_F4,LB1
         LD    ZC_F6,8+LB1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,ZCVT_WORKAREA+0
         LD    ZC_F3,8+ZCVT_WORKAREA+0
         AXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,ZCVT_WORKAREA+0
         STD   ZC_F2,8+ZCVT_WORKAREA+0
         MNOTE 'ZC_CALC   MOVE TMP-2,9,16,0 TMP-1,9,16,0'
         MVC   ZCVT_WORKAREA+16(16),16-16+ZCVT_WORKAREA+0 ALN RIGHT 9ZP
         MNOTE 'ZC_CALC   ADD TMP-2,9,16,0 ED1,7,4,0'
         LE    ZC_F4,ED1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_ED,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,ZCVT_WORKAREA+16
         LD    ZC_F3,8+ZCVT_WORKAREA+16
         AXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,ZCVT_WORKAREA+16
         STD   ZC_F2,8+ZCVT_WORKAREA+16
         MNOTE 'ZC_CALC   MOVE TMP-1,9,16,0 TMP-2,9,16,0'
         MVC   ZCVT_WORKAREA+0(16),16-16+ZCVT_WORKAREA+16 ALN RIGHT 9ZP
         MNOTE 'ZC_CALC   ADD TMP-1,9,16,0 DD1,8,8,0'
         LD    ZC_F4,DD1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_DD,PFPO_RNDX
               )
         PFPO 
         LD    ZC_F1,ZCVT_WORKAREA+0
         LD    ZC_F3,8+ZCVT_WORKAREA+0
         AXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,ZCVT_WORKAREA+0
         STD   ZC_F2,8+ZCVT_WORKAREA+0
         MNOTE 'ZC_CALC   MOVE TMP-2,9,16,0 TMP-1,9,16,0'
         MVC   ZCVT_WORKAREA+16(16),16-16+ZCVT_WORKAREA+0 ALN RIGHT 9ZP
         MNOTE 'ZC_CALC   ADD TMP-2,9,16,0 LD1,9,16,0'
         LD    ZC_F0,LD1
         LD    ZC_F2,8+LD1
         LD    ZC_F1,ZCVT_WORKAREA+16
         LD    ZC_F3,8+ZCVT_WORKAREA+16
         AXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,ZCVT_WORKAREA+16
         STD   ZC_F2,8+ZCVT_WORKAREA+16
         MNOTE 'ZC_CALC   MOVE TMP-1,9,16,0 TMP-2,9,16,0'
         MVC   ZCVT_WORKAREA+0(16),16-16+ZCVT_WORKAREA+16 ALN RIGHT 9ZP
         MNOTE 'ZC_CALC   ADD TMP-1,9,16,0 H1,H,2,1'
         LGH   ZC_R0,H1
         CXGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=LD'1E1'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_WORKAREA+0
         LD    ZC_F3,8+ZCVT_WORKAREA+0
         AXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,ZCVT_WORKAREA+0
         STD   ZC_F2,8+ZCVT_WORKAREA+0
         MNOTE 'ZC_CALC   MOVE TMP-2,9,16,0 TMP-1,9,16,0'
         MVC   ZCVT_WORKAREA+16(16),16-16+ZCVT_WORKAREA+0 ALN RIGHT 9ZP
         MNOTE 'ZC_CALC   ADD TMP-2,9,16,0 F1,F,4,2'
         LGF   ZC_R0,F1
         CXGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=LD'1E2'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_WORKAREA+16
         LD    ZC_F3,8+ZCVT_WORKAREA+16
         AXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,ZCVT_WORKAREA+16
         STD   ZC_F2,8+ZCVT_WORKAREA+16
         MNOTE 'ZC_CALC   MOVE TMP-1,9,16,0 TMP-2,9,16,0'
         MVC   ZCVT_WORKAREA+0(16),16-16+ZCVT_WORKAREA+16 ALN RIGHT 9ZP
         MNOTE 'ZC_CALC   ADD TMP-1,9,16,0 G1,G,8,3'
         LG    ZC_R0,G1
         CXGTR ZC_F0,ZC_R0
         LARL  ZC_R1,=LD'1E3'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_WORKAREA+0
         LD    ZC_F3,8+ZCVT_WORKAREA+0
         AXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,ZCVT_WORKAREA+0
         STD   ZC_F2,8+ZCVT_WORKAREA+0
         MNOTE 'ZC_CALC   MOVE TMP-2,9,16,0 TMP-1,9,16,0'
         MVC   ZCVT_WORKAREA+16(16),16-16+ZCVT_WORKAREA+0 ALN RIGHT 9ZP
         MNOTE 'ZC_CALC   ADD TMP-2,9,16,0 Q1,Q,16,4'
         LG    ZC_R0,Q1
         LG    ZC_R1,8+Q1
         L     ZC_R15,ZCVT_CVTQTLB   CVT Q IN ZC_R0-ZC_R1              X
                                     TO LB IN ZC_F4-ZC_F6
         BASR  ZC_R14,ZC_R15
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LB,PFPO_RNDX
               )
         PFPO 
         LARL  ZC_R1,=LD'1E4'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_WORKAREA+16
         LD    ZC_F3,8+ZCVT_WORKAREA+16
         AXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,ZCVT_WORKAREA+16
         STD   ZC_F2,8+ZCVT_WORKAREA+16
         MNOTE 'ZC_CALC   MOVE TMP-1,9,16,0 TMP-2,9,16,0'
         MVC   ZCVT_WORKAREA+0(16),16-16+ZCVT_WORKAREA+16 ALN RIGHT 9ZP
         MNOTE 'ZC_CALC   ADD TMP-1,9,16,0 P1,P,16,5'
         ZAP   ZCVT_PWORK1,P1
         LMG   ZC_R0,ZC_R1,ZCVT_PWORK1
         CXSTR ZC_F0,ZC_R0
         LARL  ZC_R1,=LD'1E5'
         LD    ZC_F1,0(ZC_R1)
         LD    ZC_F3,8(ZC_R1)
         DXTR  ZC_F0,ZC_F0,ZC_F1
         LD    ZC_F1,ZCVT_WORKAREA+0
         LD    ZC_F3,8+ZCVT_WORKAREA+0
         AXTR  ZC_F0,ZC_F0,ZC_F1
         STD   ZC_F0,ZCVT_WORKAREA+0
         STD   ZC_F2,8+ZCVT_WORKAREA+0
         MNOTE 'ZC_CALC   MOVE PSUM,P,3,1 TMP-1,9,16,0'
         LD    ZC_F4,ZCVT_WORKAREA+0
         LD    ZC_F6,8+ZCVT_WORKAREA+0
         LARL  ZC_R1,=LD'1E1'
         LD    ZC_F3,8(ZC_R1)
         LD    ZC_F1,0(ZC_R1)
         MXTR  ZC_F4,ZC_F4,ZC_F1
         LRL   ZC_R0,=AL1(PFPO_RADIX,PFPO_TYPE_LD,PFPO_TYPE_LD,PFPO_RNDX
               )
         PFPO 
         L     ZC_R15,ZCVT_CVTLDTP IN F0-F2 TO PL31 IN ZC_R0-ZC_R1
         BASR  ZC_R14,ZC_R15
         STMG  ZC_R0,ZC_R1,ZCVT_PWORK2
         ZAP   PSUM,ZCVT_PWORK2
         MNOTE 'ZC_CALC   ADD PSUM,P,3,1 Z1,Z,31,6'
         PACK  ZCVT_PWORK2(8),0+Z1(15) PACK #1 FULL
         PACK  7+ZCVT_PWORK2(8),14+Z1(15) PACK #2 FULL
         PACK  14+ZCVT_PWORK2(2),28+Z1(3)  PACK #3 FINAL
        SRP ZCVT_PWORK2,64-5,0
        AP    PSUM,ZCVT_PWORK2
*            GOBACK.
*ZC     32         GOBACK
         LH    ZC_R1,RETURN_CODE      PASS RETURN CODE IN R1
         L     ZC_R15,ZCVT_GOBACK
         BR    ZC_R15
SN_END_PROCEDURE DS 0H SECTION
         DROP     ZC_R4
*        PROCEDURE END
         LH    ZC_R1,RETURN_CODE
         L     ZC_R15,ZCVT_GOBACK
         BASR  ZC_R14,ZC_R15
         LTORG 
*    ZCOBOL WORKING STORAGE SECTION DATA ITEMS 
*    LVL DATA NAME                      ADDR     LEN      DUP TYP PIC  X
                     VALUE 
*    01  ZC_SAVEAREA                    00000000 00000048 1   X   X(72)X
                      
*    01  ZC_WS_ID                       00000048 00000008 1   X   X(8) X
                     ''WS*WS*WS'' 
*    01  ZC_WS_START                    00000050 00000004 1   A        X
                      
*    01  ZC_WS_LEN                      00000054 00000004 1   F   9(9) X
                      
*    01  FILLER                         00000058 00000000 1   X        X
                      
*    01  ZC_WS_ID1                      00000058 00000007 1   X   X(7) X
                     ''ZCWSID1'' 
*    01  DEBUG_ITEM                     0000005F 00000058 1   X        X
                      
*    02  DEBUG_LINE                     0000005F 00000006 1   X   X(6) X
                      
*    02  FILLER                         00000065 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_NAME                     00000066 0000001E 1   X   X(30)X
                      
*    02  FILLER                         00000084 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_1                    00000085 00000004 1   Z   9999 X
                      
*    02  FILLER                         00000089 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_2                    0000008A 00000004 1   Z   9999 X
                      
*    02  FILLER                         0000008E 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_3                    0000008F 00000004 1   Z   9999 X
                      
*    02  FILLER                         00000093 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_CONTENTS                 00000094 00000023 1   X   X(35)X
                      
*    01  TRUE                           000000B7 00000001 1   Z   9    X
                     1 
*    01  FALSE                          000000B8 00000001 1   Z   9    X
                     0 
*    01  RETURN_CODE                    000000B9 00000002 1   H   9(4) X
                     0 
*    01  ZC_ZDATA_PTR                   000000BB 00000004 1   A        X
                      
*    01  ZC_ZC_LK_END_PTR               000000BF 00000004 1   A        X
                      
ZC_WSLOC LOCTR 
ZC_WS_LOC_1  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_SAVEAREA DS CL72
ZC_WS_LOC_2  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_WS_ID DC CL8'WS*WS*WS'
ZC_WS_LOC_3  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_WS_START DS AL4
ZC_WS_LOC_4  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_WS_LEN DS FL4
ZC_WS_LOC_5  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DS  0CL0
ZC_WS_LOC_6  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_WS_ID1 DC CL7'ZCWSID1'
ZC_WS_LOC_25 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_ITEM DS 0CL88
ZC_WS_LOC_26 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_LINE DS CL6
ZC_WS_LOC_27 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_28 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_NAME DS CL30
ZC_WS_LOC_29 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_30 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_1 DS ZL4
ZC_WS_LOC_31 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_32 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_2 DS ZL4
ZC_WS_LOC_33 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_34 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_3 DS ZL4
ZC_WS_LOC_35 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_36 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_CONTENTS DS CL35
ZC_WS_LOC_37 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
TRUE     DC CL1'1'
ZC_WS_LOC_38 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
FALSE    DC CL1'0'
ZC_WS_LOC_39 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
RETURN_CODE DC AL2(0)                  RPI 1065
ZC_WS_LOC_40 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_ZDATA_PTR DS AL4
ZC_WS_LOC_41 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_ZC_LK_END_PTR DS AL4
*    ZCOBOL LINKAGE SECTION DATA ITEMS 
*    LVL DATA NAME                      ADDR     LEN      DUP TYP PIC  X
                     VALUE 
*    01  ZDATA                          00000000 000000A4 1   X        X
                      
*    05  EH1                            00000000 00000004 1   1        X
                      
*    05  DH1                            00000004 00000008 1   2        X
                      
*    05  LH1                            0000000C 00000010 1   3        X
                      
*    05  EB1                            0000001C 00000004 1   4        X
                      
*    05  DB1                            00000020 00000008 1   5        X
                      
*    05  LB1                            00000028 00000010 1   6        X
                      
*    05  ED1                            00000038 00000004 1   7        X
                      
*    05  DD1                            0000003C 00000008 1   8        X
                      
*    05  LD1                            00000044 00000010 1   9        X
                      
*    05  H1                             00000054 00000002 1   H   9(3)VX
               9     0 
*    05  F1                             00000056 00000004 1   F   9(7)VX
               99    00 
*    05  G1                             0000005A 00000008 1   G   9(15)X
               V999  000 
*    05  Q1                             00000062 00000010 1   Q   9(35)X
               V9999 0000 
*    05  P1                             00000072 00000010 1   P   9(26)X
               V9(5) 00000 
*    05  Z1                             00000082 0000001F 1   Z   9(25)X
               V9(6) 000000 
*    05  PSUM                           000000A1 00000003 1   P   9(4)VX
               9     0 
*    01  ZC_LK_END                      00000000 00000001 1   X   X    X
                      
ZC_WSLOC LOCTR 
ZDATA_DSECT DSECT 
ZC_LK_LOC_7  EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
ZDATA    DS  0CL164
ZC_LK_LOC_8  EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
EH1      DS EHL4
ZC_LK_LOC_9  EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
DH1      DS DHL8
ZC_LK_LOC_10 EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
LH1      DS LHL16
ZC_LK_LOC_11 EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
EB1      DS EBL4
ZC_LK_LOC_12 EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
DB1      DS DBL8
ZC_LK_LOC_13 EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
LB1      DS LBL16
ZC_LK_LOC_14 EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
ED1      DS EDL4
ZC_LK_LOC_15 EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
DD1      DS DDL8
ZC_LK_LOC_16 EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
LD1      DS LDL16
ZC_LK_LOC_17 EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
H1       DS  HL2
ZC_LK_LOC_18 EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
F1       DS  FL4
ZC_LK_LOC_19 EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
G1       DS  FL8
ZC_LK_LOC_20 EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
Q1       DS FL16
ZC_LK_LOC_21 EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
P1       DS  PL16
ZC_LK_LOC_22 EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
Z1       DS  ZL31
ZC_LK_LOC_23 EQU *-ZDATA CHECK &SYM_NAME(&I) LK LOC
PSUM     DS  PL3
ZC_LK_END_DSECT DSECT 
ZC_LK_LOC_24 EQU *-ZC_LK_END CHECK &SYM_NAME(&I) LK LOC
ZC_LK_END DS CL1
ZC_WSLOC LOCTR 
ZC_WS_DIFF EQU  *-ZC_WS-195  DIFF BETWEEN ALLOC AND CALC WS
ZC_WS_END DS   0D
         MNOTE *,'ZCOBOL TOTAL SYMBOLS                 = 41'
         MNOTE *,'ZCOBOL TOTAL SYMBOL DUPLICATES       = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL MAX DUP CHAIN    = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LEVEL 88         = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL SET INDEXES      = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LINKAGE SECTIONS = 2'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE SECTIONS      = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPHS    = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPH DUP = 0'
         END 
