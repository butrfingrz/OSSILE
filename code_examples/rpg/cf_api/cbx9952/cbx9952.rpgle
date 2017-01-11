     **
     **  Program . . : CBX9952
     **  Description : Work with Job Queue Entries - CPP
     **  Author  . . : Carsten Flensburg
     **  Published . : System iNetwork Systems Management Tips Newsletter
     **
     **
     **
     **  Compile options:
     **    CrtRpgMod   Module( CBX9952 )
     **                DbgView( *LIST )
     **
     **    CrtPgm      Pgm( CBX9952 )
     **                Module( CBX9952 )
     **                ActGrp( *NEW )
     **
     **-- Header specifications:  --------------------------------------------**
     H Option( *SrcStmt )
 
     **-- API error data structure:
     D ERRC0100        Ds                  Qualified
     D  BytPrv                       10i 0 Inz( %Size( ERRC0100 ))
     D  BytAvl                       10i 0
     D  MsgId                         7a
     D                                1a
     D  MsgDta                      128a
 
     **-- Global constants:
     D OFS_MSGDTA      c                   16
     D USRSPC_Q        c                   'LSTJOBQ   QTEMP'
     D EXT_ATR         c                   ' '
     D USP_SIZ         c                   65535
     D INZ_VAL         c                   x'00'
     D PUB_AUT         c                   '*CHANGE'
     D TXT_DSC         c                   ' '
     D USP_RPL         c                   '*YES'
     **-- UIM constants:
     D PNLGRP_Q        c                   'CBX9952P  *LIBL     '
     D PNLGRP          c                   'CBX9952P   '
     D SCP_AUT_RCL     c                   -1
     D RDS_OPT_INZ     c                   'N'
     D PRM_IFC_0       c                   0
     D CLO_NORM        c                   'M'
     D FNC_EXIT        c                   -4
     D FNC_CNL         c                   -8
     D KEY_F05         c                   5
     D KEY_F24         c                   24
     D RTN_ENTER       c                   500
     D HLP_WDW         c                   'N'
     D POS_TOP         c                   'TOP'
     D POS_BOT         c                   'BOT'
     D LIST_COMP       c                   'ALL'
     D LIST_SAME       c                   'SAME'
     D EXIT_SAME       c                   '*SAME'
     D TRIM_SAME       c                   'S'
 
     **-- Global variables:
     D Idx             s             10i 0
     D SysDts          s               z
 
     **-- UIM variables:
     D UIM             Ds                  Qualified
     D  AppHdl                        8a
     D  LstHdl                        4a
     D  EntHdl                        4a
     D  FncRqs                       10i 0
     D  EntLocOpt                     4a
     D  LstPos                        4a
     **-- List attributes structure:
     D LstAtr          Ds                  Qualified
     D  LstCon                        4a
     D  ExtPgmVar                    10a
     D  DspPos                        4a
     D  AlwTrim                       1a
 
     **-- UIM Panel exit program record:
     D ExpRcd          Ds                  Qualified
     D  ExitPg                       20a   Inz( 'CBX9952E  *LIBL' )
     **-- UIM Panel header record:
     D HdrRcd          Ds                  Qualified
     D  SysDat                        7a
     D  SysTim                        6a
     D  TimZon                       10a
     D  SbsNam                       10a
     D  SbsLib                       10a
     D  SbsSts                       10a
     D  MaxActJob                     7s 0
     **-- UIM List entry:
     D LstEnt          Ds                  Qualified
     D  Option                        5i 0
     D  SeqNbr                        4s 0
     D  JobQue_q                     20a
     D   JobQue                      10a   Overlay( JobQue_q: 1 )
     D   JobQueLib                   10a   Overlay( JobQue_q: *Next )
     D  JobQueSts                     1a
     D  MaxAct                        7s 0
     D  CurAct                        7s 0
     D  NbrJobOnQue                   7s 0
     D  QueDsc                       50a
     D  MaxPty1                       2s 0
     D  MaxPty2                       2s 0
     D  MaxPty3                       2s 0
     D  MaxPty4                       2s 0
     D  MaxPty5                       2s 0
     D  MaxPty6                       2s 0
     D  MaxPty7                       2s 0
     D  MaxPty8                       2s 0
     D  MaxPty9                       2s 0
     **
     D LstEntPos       Ds                  LikeDs( LstEnt )
 
     **-- List API parameters:
     D LstApi          Ds                  Qualified  Inz
     D  RtnRcdNbr                    10i 0 Inz( 1 )
     D  NbrFldRtn                    10i 0 Inz( %Elem( LstApi.KeyFld ))
     D  KeyFld                       10i 0 Dim( 10 )
 
     **-- Subsystem information:
     D SBSI0100        Ds                  Qualified  Inz
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  SbsNam_q                     20a
     D   SbsNam                      10a   Overlay( SbsNam_q:  1 )
     D   SbsLib                      10a   Overlay( SbsNam_q: 11 )
     D  SbsSts                       10a
     D  SgnDevName                   10a
     D  SgnDevLib                    10a
     D  SecLngLib                    10a
     D  MaxActJob                    10i 0
     D  CurActJob                    10i 0
     D  NbrPools                     10i 0
     D  PoolInf                            Dim( 10 )
     D   PoolId                      10i 0 Overlay( PoolInf: 1 )
     D   PoolNam                     10a   Overlay( PoolInf: *Next )
     D                                6a   Overlay( PoolInf: *Next )
     D   PoolSiz                     10i 0 Overlay( PoolInf: *Next )
     D   PoolActLvl                  10i 0 Overlay( PoolInf: *Next )
     **-- Job queue information:
     D SJQL0100        Ds                  Qualified  Based( pLstEnt )
     D  JobQue_q                     20a
     D   JobQueNam                   10a   Overlay( JobQue_q:  1 )
     D   JobQueLib                   10a   Overlay( JobQue_q: 11 )
     D  SeqNbr                       10i 0
     D  AlcInd                       10a
     D                                2a
     D  MaxAct                       10i 0
     D  MaxPty1                      10i 0
     D  MaxPty2                      10i 0
     D  MaxPty3                      10i 0
     D  MaxPty4                      10i 0
     D  MaxPty5                      10i 0
     D  MaxPty6                      10i 0
     D  MaxPty7                      10i 0
     D  MaxPty8                      10i 0
     D  MaxPty9                      10i 0
     **-- Job queue information (partial):
     D JOBQ0200        Ds          4000    Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  JobQue_q                     20a
     D   JobQueNam                   10a   Overlay( JobQue_q:  1 )
     D   JobQueLib                   10a   Overlay( JobQue_q: 11 )
     D  OprCtl                       10a
     D  AutChk                       10a
     D  NbrJobOnQue                  10i 0
     D  JobQueSts                    10a
     D  SbsNam_Q                     20a
     D   SbsNam                      10a   Overlay( SbsNam_q:  1 )
     D   SbsLib                      10a   Overlay( SbsNam_q: 11 )
     D  QueDsc                       50a
     D  SeqNbr                       10i 0
     D  MaxAct                       10i 0
     D  CurAct                       10i 0
     D  MaxPty1                      10i 0
     D  MaxPty2                      10i 0
     D  MaxPty3                      10i 0
     D  MaxPty4                      10i 0
     D  MaxPty5                      10i 0
     D  MaxPty6                      10i 0
     D  MaxPty7                      10i 0
     D  MaxPty8                      10i 0
     D  MaxPty9                      10i 0
     D  ActPty0                      10i 0
     D  ActPty1                      10i 0
     D  ActPty2                      10i 0
     D  ActPty3                      10i 0
     D  ActPty4                      10i 0
     D  ActPty5                      10i 0
     D  ActPty6                      10i 0
     D  ActPty7                      10i 0
     D  ActPty8                      10i 0
     D  ActPty9                      10i 0
     D  RlsPty0                      10i 0
     D  RlsPty1                      10i 0
     D  RlsPty2                      10i 0
     D  RlsPty3                      10i 0
     D  RlsPty4                      10i 0
     D  RlsPty5                      10i 0
     D  RlsPty6                      10i 0
     D  RlsPty7                      10i 0
     D  RlsPty8                      10i 0
     D  RlsPty9                      10i 0
     D  ScdPty0                      10i 0
     D  ScdPty1                      10i 0
     D  ScdPty2                      10i 0
     D  ScdPty3                      10i 0
     D  ScdPty4                      10i 0
     D  ScdPty5                      10i 0
     D  ScdPty6                      10i 0
     D  ScdPty7                      10i 0
     D  ScdPty8                      10i 0
     D  ScdPty9                      10i 0
     D  HldPty0                      10i 0
     D  HldPty1                      10i 0
     D  HldPty2                      10i 0
     D  HldPty3                      10i 0
     D  HldPty4                      10i 0
     D  HldPty5                      10i 0
     D  HldPty6                      10i 0
     D  HldPty7                      10i 0
     D  HldPty8                      10i 0
     D  HldPty9                      10i 0
 
     **-- User space generic header:
     D UsrSpcHdr       Ds                  Qualified  Based( pUsrSpc )
     D  OfsInpSec                    10i 0 Overlay( UsrSpcHdr: 109 )
     D  SizInpSec                    10i 0 Overlay( UsrSpcHdr: 113 )
     D  OfsHdrSec                    10i 0 Overlay( UsrSpcHdr: 117 )
     D  SizHdrSec                    10i 0 Overlay( UsrSpcHdr: 121 )
     D  OfsLstEnt                    10i 0 Overlay( UsrSpcHdr: 125 )
     D  NumLstEnt                    10i 0 Overlay( UsrSpcHdr: 133 )
     D  SizLstEnt                    10i 0 Overlay( UsrSpcHdr: 137 )
     **-- User space pointers:
     D pUsrSpc         s               *   Inz( *Null )
     D pHdrInf         s               *   Inz( *Null )
     D pLstEnt         s               *   Inz( *Null )
     **-- API input information:
     D ApiInpInf       Ds                  Qualified  Based( pInpInf )
     D  UsrSpcNamSpf                 10a
     D  UsrSpcLibSpf                 10a
     D  FmtNamSpf                     8a
     D  SbsNamSpf                    10a
     D  SbsLibSpf                    10a
     **-- API header information:
     D ApiHdrInf       Ds                  Qualified  Based( pHdrInf )
     D  SbsNamUsd                    10a
     D  SbsLibUsd                    10a
 
     **-- List subsystem entries:
     D LstSbsEnt       Pr                  ExtPgm( 'QWDLSBSE' )
     D  UsrSpc_Q                     20a   Const
     D  FmtNam                       10a   Const
     D  SbsNam_q                     20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- List subsystem job queues:
     D LstSbsJobQ      Pr                  ExtPgm( 'QWDLSJBQ' )
     D  UsrSpc_q                     20a   Const
     D  FmtNam                       10a   Const
     D  SbsNam_q                     20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve job queue information:
     D RtvJobQueInf    Pr                  ExtPgm( 'QSPRJOBQ' )
     D  RcvVar                    65535a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  JobQue_q                     20a   Const
     D  Error                      1024a          Options( *VarSize )
     **-- Retrieve subsystem information:
     D RtvSbsInf       Pr                  ExtPgm( 'QWDRSBSD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                       10a   Const
     D  SbsNam_q                     20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Create user space:
     D CrtUsrSpc       Pr                  ExtPgm( 'QUSCRTUS' )
     D  SpcNam_q                     20a   Const
     D  ExtAtr                       10a   Const
     D  InzSiz                       10i 0 Const
     D  InzVal                        1a   Const
     D  PubAut                       10a   Const
     D  Text                         50a   Const
     D  Replace                      10a   Const  Options( *NoPass )
     D  Error                     32767a          Options( *NoPass: *VarSize )
     D  Domain                       10a   Const  Options( *NoPass )
     **-- Delete user space:
     D DltUsrSpc       Pr                  ExtPgm( 'QUSDLTUS' )
     D  SpcNam_q                     20a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve pointer to user space:
     D RtvPtrSpc       Pr                  ExtPgm( 'QUSPTRUS' )
     D  SpcNam_q                     20a   Const
     D  Pointer                        *
     D  Error                     32767a          Options( *NoPass: *VarSize )
     **-- Send program message:
     D SndPgmMsg       Pr                  ExtPgm( 'QMHSNDPM' )
     D  MsgId                         7a   Const
     D  MsgFil_q                     20a   Const
     D  MsgDta                      128a   Const
     D  MsgDtaLen                    10i 0 Const
     D  MsgTyp                       10a   Const
     D  CalStkE                      10a   Const  Options( *VarSize )
     D  CalStkCtr                    10i 0 Const
     D  MsgKey                        4a
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve object description:
     D RtvObjD         Pr                  ExtPgm( 'QUSROBJD' )
     D  RcvVar                    32767a          Options( *VarSize )
     D  RcvVarLen                    10i 0 Const
     D  FmtNam                        8a   Const
     D  ObjNam_q                     20a   Const
     D  ObjTyp                       10a   Const
     D  Error                     32767a          Options( *VarSize )
 
     **-- Open display application:
     D OpnDspApp       Pr                  ExtPgm( 'QUIOPNDA' )
     D  AppHdl                        8a
     D  PnlGrp_q                     20a   Const
     D  AppScp                       10i 0 Const
     D  ExtPrmIfc                    10i 0 Const
     D  FulScrHlp                     1a   Const
     D  Error                     32767a          Options( *VarSize )
     D  OpnDtaRcv                   128a          Options( *NoPass: *VarSize )
     D  OpnDtaRcvLen                 10i 0 Const  Options( *NoPass )
     D  OpnDtaRcvAvl                 10i 0        Options( *NoPass )
     **-- Display panel:
     D DspPnl          Pr                  ExtPgm( 'QUIDSPP' )
     D  AppHdl                        8a   Const
     D  FncRqs                       10i 0
     D  PnlNam                       10a   Const
     D  ReDspOpt                      1a   Const
     D  Error                     32767a          Options( *VarSize )
     D  UsrTsk                        1a   Const  Options( *NoPass )
     D  CalStkCnt                    10i 0 Const  Options( *NoPass )
     D  CalMsgQue                   256a   Const  Options( *NoPass: *VarSize )
     D  MsgKey                        4a   Const  Options( *NoPass )
     D  CsrPosOpt                     1a   Const  Options( *NoPass )
     D  FinLstEnt                     4a   Const  Options( *NoPass )
     D  ErrLstEnt                     4a   Const  Options( *NoPass )
     D  WaitTim                      10i 0 Const  Options( *NoPass )
     D  CalMsgQueLen                 10i 0 Const  Options( *NoPass )
     D  CalQlf                       20a   Const  Options( *NoPass )
     **-- Put dialog variable:
     D PutDlgVar       Pr                  ExtPgm( 'QUIPUTV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Get dialog variable:
     D GetDlgVar       Pr                  ExtPgm( 'QUIGETV' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a          Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Add list entry:
     D AddLstEnt       Pr                  ExtPgm( 'QUIADDLE' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  LstNam                       10a   Const
     D  EntLocOpt                     4a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )
     **-- Get list entry:
     D GetLstEnt       Pr                  ExtPgm( 'QUIGETLE' )
     D  AppHdl                        8a   Const
     D  VarBuf                    32767a   Const  Options( *VarSize )
     D  VarBufLen                    10i 0 Const
     D  VarRcdNam                    10a   Const
     D  LstNam                       10a   Const
     D  PosOpt                        4a   Const
     D  CpyOpt                        1a   Const
     D  SltCri                       20a   Const
     D  SltHdl                        4a   Const
     D  ExtOpt                        1a   Const
     D  LstEntHdl                     4a
     D  Error                     32767a          Options( *VarSize )
     **-- Retrieve list attributes:
     D RtvLstAtr       Pr                  ExtPgm( 'QUIRTVLA' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  AtrRcv                    32767a          Options( *VarSize )
     D  AtrRcvLen                    10i 0 Const
     D  Error                     32767a          Options( *VarSize )
     **-- Set list attributes:
     D SetLstAtr       Pr                  ExtPgm( 'QUISETLA' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  LstCon                        4a   Const
     D  ExtPgmVar                    10a   Const
     D  DspPos                        4a   Const
     D  AlwTrim                       1a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Delete list:
     D DltLst          Pr                  ExtPgm( 'QUIDLTL' )
     D  AppHdl                        8a   Const
     D  LstNam                       10a   Const
     D  Error                     32767a          Options( *VarSize )
     **-- Close application:
     D CloApp          Pr                  ExtPgm( 'QUICLOA' )
     D  AppHdl                        8a   Const
     D  CloOpt                        1a   Const
     D  Error                     32767a          Options( *VarSize )
 
     **-- Get object library:
     D GetObjLib       Pr            10a
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **-- Send escape message:
     D SndEscMsg       Pr            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
 
     **-- Entry parameters:
     D ObjNam_q        Ds
     D  ObjNam                       10a
     D  ObjLib                       10a
     **
     D CBX9952         Pr
     D  PxSbsNam_q                         LikeDs( ObjNam_q )
     **
     D CBX9952         Pi
     D  PxSbsNam_q                         LikeDs( ObjNam_q )
 
      /Free
 
        OpnDspApp( UIM.AppHdl
                 : PNLGRP_Q
                 : SCP_AUT_RCL
                 : PRM_IFC_0
                 : HLP_WDW
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          ExSr  EscApiErr;
        EndIf;
 
        CrtUsrSpc( USRSPC_Q
                 : EXT_ATR
                 : USP_SIZ
                 : INZ_VAL
                 : PUB_AUT
                 : TXT_DSC
                 : USP_RPL
                 : ERRC0100
                 );
 
        PutDlgVar( UIM.AppHdl: ExpRcd: %Size( ExpRcd ): 'EXPRCD': ERRC0100 );
 
        ExSr  BldHdrRcd;
        ExSr  BldJobQueLst;
 
        DoU  UIM.FncRqs = FNC_EXIT  Or  UIM.FncRqs = FNC_CNL;
 
          DspPnl( UIM.AppHdl: UIM.FncRqs: PNLGRP: RDS_OPT_INZ: ERRC0100 );
 
          Select;
          When  ERRC0100.BytAvl > *Zero;
            ExSr  EscApiErr;
 
          When  UIM.FncRqs = RTN_ENTER;
            Leave;
          EndSl;
 
          GetDlgVar( UIM.AppHdl: HdrRcd: %Size( HdrRcd ): 'HDRRCD': ERRC0100 );
 
          If  UIM.FncRqs = KEY_F05  And  UIM.EntLocOpt = 'NEXT';
            ExSr  GetLstPos;
            ExSr  DltJobQueLst;
          EndIf;
 
          If  UIM.FncRqs = KEY_F05;
            ExSr  BldJobQueLst;
            ExSr  SetLstPos;
          EndIf;
 
          ExSr  BldHdrRcd;
        EndDo;
 
        CloApp( UIM.AppHdl: CLO_NORM: ERRC0100 );
 
        DltUsrSpc( USRSPC_Q: ERRC0100 );
 
        *InLr = *On;
        Return;
 
 
        BegSr  BldJobQueLst;
 
          UIM.EntLocOpt = 'FRST';
 
          LstSbsJobQ( USRSPC_Q: 'SJQL0100': PxSbsNam_q: ERRC0100 );
 
          If  ERRC0100.BytAvl = *Zero;
            ExSr  PrcUsrSpc;
          EndIf;
 
          SetLstAtr( UIM.AppHdl
                   : 'DTLLST'
                   : LIST_COMP
                   : EXIT_SAME
                   : POS_TOP
                   : TRIM_SAME
                   : ERRC0100
                   );
 
        EndSr;
 
        BegSr  PrcUsrSpc;
 
          RtvPtrSpc( USRSPC_Q: pUsrSpc );
 
          pInpInf = pUsrSpc + UsrSpcHdr.OfsInpSec;
          pHdrInf = pUsrSpc + UsrSpcHdr.OfsHdrSec;
          pLstEnt = pUsrSpc + UsrSpcHdr.OfsLstEnt;
 
          For  Idx = 1  to UsrSpcHdr.NumLstEnt;
 
            ExSr  GetJobQueInf;
 
            LstEnt.Option = *Zero;
 
            LstEnt.SeqNbr      = SJQL0100.SeqNbr;
            LstEnt.JobQue_q    = SJQL0100.JobQue_q;
            LstEnt.MaxAct      = SJQL0100.MaxAct;
 
            LstEnt.JobQueSts   = JOBQ0200.JobQueSts;
            LstEnt.CurAct      = JOBQ0200.CurAct;
            LstEnt.NbrJobOnQue = JOBQ0200.NbrJobOnQue;
            LstEnt.QueDsc      = JOBQ0200.QueDsc;
            LstEnt.MaxPty1     = SJQL0100.MaxPty1;
            LstEnt.MaxPty2     = SJQL0100.MaxPty2;
            LstEnt.MaxPty3     = SJQL0100.MaxPty3;
            LstEnt.MaxPty4     = SJQL0100.MaxPty4;
            LstEnt.MaxPty5     = SJQL0100.MaxPty5;
            LstEnt.MaxPty6     = SJQL0100.MaxPty6;
            LstEnt.MaxPty7     = SJQL0100.MaxPty7;
            LstEnt.MaxPty8     = SJQL0100.MaxPty8;
            LstEnt.MaxPty9     = SJQL0100.MaxPty9;
 
            AddLstEnt( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : 'DTLRCD'
                     : 'DTLLST'
                     : UIM.EntLocOpt
                     : UIM.LstHdl
                     : ERRC0100
                     );
 
            UIM.EntLocOpt = 'NEXT';
 
            If  Idx < UsrSpcHdr.NumLstEnt;
              pLstEnt += UsrSpcHdr.SizLstEnt;
            EndIf;
          EndFor;
 
        EndSr;
 
        BegSr  GetJobQueInf;
 
          RtvJobQueInf( JOBQ0200
                      : %Size( JOBQ0200 )
                      : 'JOBQ0200'
                      : SJQL0100.JobQue_q
                      : ERRC0100
                      );
 
          If  ERRC0100.BytAvl > *Zero;
            Clear  JOBQ0200;
          EndIf;
 
        EndSr;
 
        BegSr  GetLstPos;
 
          RtvLstAtr( UIM.AppHdl: 'DTLLST': LstAtr: %Size( LstAtr ): ERRC0100 );
 
          If  LstAtr.DspPos <> 'TOP';
 
            GetLstEnt( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : 'DTLRCD'
                     : 'DTLLST'
                     : 'HNDL'
                     : 'Y'
                     : *Blanks
                     : LstAtr.DspPos
                     : 'N'
                     : UIM.EntHdl
                     : ERRC0100
                     );
 
            LstEntPos = LstEnt;
          EndIf;
 
        EndSr;
 
        BegSr  SetLstPos;
 
          If  LstAtr.DspPos <> 'TOP';
 
            LstEnt = LstEntPos;
 
            PutDlgVar( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : 'DTLRCD'
                     : ERRC0100
                     );
 
            GetLstEnt( UIM.AppHdl
                     : LstEnt
                     : %Size( LstEnt )
                     : '*NONE'
                     : 'DTLLST'
                     : 'FSLT'
                     : 'N'
                     : 'EQ        SEQNBR'
                     : LstAtr.DspPos
                     : 'N'
                     : UIM.EntHdl
                     : ERRC0100
                     );
 
            If  ERRC0100.BytAvl = *Zero;
 
              SetLstAtr( UIM.AppHdl
                       : 'DTLLST'
                       : LIST_SAME
                       : EXIT_SAME
                       : UIM.EntHdl
                       : TRIM_SAME
                       : ERRC0100
                       );
 
            EndIf;
          EndIf;
 
        EndSr;
 
        BegSr  BldHdrRcd;
 
          SysDts = %Timestamp();
 
          HdrRcd.SysDat = %Char( %Date( SysDts ): *CYMD0 );
          HdrRcd.SysTim = %Char( %Time( SysDts ): *HMS0 );
          HdrRcd.TimZon = '*SYS';
 
          ExSr  GetSbsInf;
 
          HdrRcd.SbsNam    = SBSI0100.SbsNam;
          HdrRcd.SbsLib    = SBSI0100.SbsLib;
          HdrRcd.SbsSts    = SBSI0100.SbsSts;
          HdrRcd.MaxActJob = SBSI0100.MaxActJob;
 
          PutDlgVar( UIM.AppHdl: HdrRcd: %Size( HdrRcd ): 'HDRRCD': ERRC0100 );
 
        EndSr;
 
        BegSr  DltJobQueLst;
 
          DltLst( UIM.AppHdl: 'DTLLST': ERRC0100 );
 
        EndSr;
 
        BegSr  GetSbsInf;
 
          RtvSbsInf( SBSI0100
                   : %Size( SBSI0100 )
                   : 'SBSI0100'
                   : PxSbsNam_q
                   : ERRC0100
                   );
 
          If  ERRC0100.BytAvl > *Zero;
            Reset  SBSI0100;
          EndIf;
 
        EndSr;
 
        BegSr  EscApiErr;
 
          If  ERRC0100.BytAvl < OFS_MSGDTA;
            ERRC0100.BytAvl = OFS_MSGDTA;
          EndIf;
 
          SndEscMsg( ERRC0100.MsgId
                   : 'QCPFMSG'
                   : %Subst( ERRC0100.MsgDta: 1: ERRC0100.BytAvl - OFS_MSGDTA )
                   );
 
        EndSr;
 
        BegSr  *InzSr;
 
          If  PxSbsNam_q.ObjLib = '*LIBL';
            PxSbsNam_q.ObjLib = GetObjLib( PxSbsNam_q: '*SBSD' );
          EndIf;
 
        EndSr;
 
      /End-Free
 
     **-- Get object library:
     P GetObjLib       B
     D                 Pi            10a
     D  PxObjNam_q                   20a   Const
     D  PxObjTyp                     10a   Const
     **
     D OBJD0100        Ds                  Qualified
     D  BytRtn                       10i 0
     D  BytAvl                       10i 0
     D  ObjNam                       10a
     D  ObjLib                       10a
     D  ObjTyp                       10a
     D  ObjLibRtn                    10a
     D  ObjASP                       10i 0
     D  ObjOwn                       10a
     D  ObjDmn                        2a
 
      /Free
 
         RtvObjD( OBJD0100
                : %Size( OBJD0100 )
                : 'OBJD0100'
                : PxObjNam_q
                : PxObjTyp
                : ERRC0100
                );
 
         If  ERRC0100.BytAvl > *Zero;
           Return  *Blanks;
 
         Else;
           Return  OBJD0100.ObjLibRtn;
         EndIf;
 
      /End-Free
 
     P GetObjLib       E
     **-- Send escape message:
     P SndEscMsg       B
     D                 Pi            10i 0
     D  PxMsgId                       7a   Const
     D  PxMsgF                       10a   Const
     D  PxMsgDta                    512a   Const  Varying
     **
     D MsgKey          s              4a
 
      /Free
 
        SndPgmMsg( PxMsgId
                 : PxMsgF + '*LIBL'
                 : PxMsgDta
                 : %Len( PxMsgDta )
                 : '*ESCAPE'
                 : '*PGMBDY'
                 : 1
                 : MsgKey
                 : ERRC0100
                 );
 
        If  ERRC0100.BytAvl > *Zero;
          Return  -1;
 
        Else;
          Return   0;
        EndIf;
 
      /End-Free
 
     P SndEscMsg       E
