{
//  Version:5.6.3   Build:1091  Date:1/31/00  //
////////////////////////////////////////////////////////////////////////////
//                                                                        //
// Copyright © 1996-1999, NetMasters, L.L.C - All rights reserved worldwide. //
//  Portions may be Copyright © Borland International, Inc.               //
//                                                                        //
// Unit Name: NMConst                                                     //
//                                                                        //
// DESCRIPTION:Internet Component Contsants                               //
//  + Aug-9-98 Version 4.1 -- KNA                                         //
//                                                                        //
// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY  //
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE    //
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR  //
// PURPOSE.                                                               //
//                                                                        //
////////////////////////////////////////////////////////////////////////////
}
unit NMConst;

interface

{$IFDEF NMF3}
   resourcestring
{$ELSE}
   const
{$ENDIF}

      Cons_Palette_Inet           = 'Internet';
      Cons_Msg_Auth_Fail          = 'Authentication failed';
      Cons_Msg_ConnectionTimedOut = 'Connection Timed out';
      
      sFTP_Dir_Name               = 'dir.lst';
      sFTP_Msg_Disconnect         = 'Disconnected';
      sFTP_Msg_Recvd              = 'Received ';
      sFTP_No_Bytes               = ' Bytes';
      sFTP_Cont_Msg_UpldS         = '226 Upload OK';

      sHTTP_Prog_Name             = 'NetMasters 4.0';
      sHTTP_Head_File             = 'Head.txt';
      sHTTP_Body_File             = 'Default.htm';
      sHTTP_Data_File             = 'Send.dat';
      
      sHTTP_Msg_Trans             = 'Transaction Completed';
      sHTTP_Exp_Parse             = 'HTTP Parsing URL failed';
      sHTTP_Cont_Msg_NoURL        = 'Empty URL';

      sSMTP_Msg_Incomp_Head       = 'Incomplete Header';

      sPOP_Cons_Summ_Retr         = 'Summary Retrieved';
      sPOP_Cons_Msg_Retr          = 'Message Retrieved';
      sPOP_Cons_Msg_File          = 'File "';
      sPOP_Cons_Msg_Extr          = '" extracted';
      sPOP_Cons_Msg_ExtrF         = 'Extracting file';
      sPOP_Cons_Msg_Deco          = 'Decoding file';

      sNNTP_Cons_CRLF             = #13#10;
      sNNTP_Cons_NewsDir          = 'C:\';
      
      sNNTP_Cons_ReadlnErr        = 'Socket readln aborted';
      sNNTP_Cons_GrpErr           = 'No Group Selected';
      sNNTP_Cons_InfoFil          = '\Info.hdd';
      sNNTP_Cons_TempEncodeFile   = 'temp.mim';
      sNNTP_Cons_InvGrpErr        = 'Invalid Group';
      sNNTP_Cons_PostingErr       = 'Posting Failed';
      sNNTP_Cons_LogInSerErr      = 'Log in to server failed';
      sNNTP_Cons_RetrErr          = 'Retreival Failed';
      sNNTP_Cons_ArtErr           = 'Article not Found';
      sNNTP_Cons_FileMsg1         = 'File "';
      sNNTP_Cons_FileMsg2         = '" extracted';

      sEcho_Cons_Msg_echoS        = 'Echo Test';

      sURL_DecodeMessage          = 'Error during decode';
      sURL_EncodeMessage          = 'Error during encode';

      sUDP_Cons_Msg_Wsk           = 'Initializing Winsock';
      sUDP_Cons_Msg_Lkp           = 'Host Lookup Canceled';
      sUDP_Cons_Msg_Data          = 'Sending Data';
      sUDP_Cons_Msg_InvStrm       = 'Invalid stream';
      sUDP_Cons_Msg_Echk          = 'Checking Error In Error Manager';
      sUDP_Cons_Msg_Eno           = 'Unknown Error No. ';
      sUDP_Cons_Msg_ELkp          = 'Looking Up Error Message';
      sUDP_Cons_Err_Addr          = 'Null Remote Address';
      sUDP_Cons_Err_Buffer        = 'Invalid buffer';

      sUUE_Cons_Msg_NoLnEnd       = ' No end line.';

      sPSk_Cons_msg_create        = 'Create';                                                                  
      sPSk_Cons_msg_Dest          = 'Destroy';                                                                
      sPSk_Cons_msg_Conn          = 'Already connected';
      sPSk_Cons_msg_CertConn      = 'Checking Connection';
      sPSk_Cons_msg_host_to       = 'Host Lookup Timed Out';                                    
      sPSk_Cons_msg_host_Can      = 'Host Lookup Canceled';                                      
      sPSk_Cons_msg_host_Fail     = 'Host Lookup Failed';                                          
      sPSk_Cons_msg_add_null      = 'Null Remote Address';                                        
      sPSk_Cons_msg_Conning       = 'Connecting';                                                          
      sPSk_Cons_msg_Conn_can      = 'Connection Canceled';                                        
      sPSk_Cons_msg_Conn_fai      = 'Connection Failed';                                            
      sPSk_Cons_msg_Disconn       = 'Disconnecting';                                                    
      sPSk_Cons_err_NotConn       = 'Not Connected';                                                    
      sPSk_Cons_err_werr          = 'Initializaton of windows sockets failed';
      sPSk_Cons_msg_Cancel        = 'Canceling';                                                            
      sPSk_Cons_msg_SBuff         = 'Sending Buffer';                                                  
      sPSk_Cons_msg_write         = 'Write';                                                                    
      sPSk_Cons_msg_writeln       = 'Writeln';                                                                
      sPSk_Cons_msg_read          = 'Read( ';                                                                  
      sPSk_Cons_msg_readln        = 'ReadLn';                                                                  
      sPSk_Cons_msg_readln_a      = 'Socket readln aborted';                                    
      sPSk_Cons_msg_transa        = 'Transaction';                                                        
      sPSk_Cons_msg_sendf         = 'SendFile';                                                              
      sPSk_Cons_msg_sendstrm      = 'SendStream';                                                          
      sPSk_Cons_msg_send_a        = 'Socket send aborted';                                        
      sPSk_Cons_msg_cap_fil       = 'CaptureFile';
      sPSk_Cons_msg_cap_fil_app   = 'Append File';                                                      
      sPSk_Cons_msg_cap_strm      = 'Capture Stream';                                                  
      sPSk_Cons_msg_cap_a         = 'Socket capture aborted';                                  
      sPSk_Cons_msg_string        = 'Capture String';
      sPSk_Cons_msg_filthead      = 'FilterHeader';
      sPSk_Cons_msg_Listen        = 'Listening';                                                            
      sPSk_Cons_err_data_conn     = 'Error creating Data Connection';                  
      sPSk_Cons_msg_accept        = 'Accepting';                                                            
      sPSk_Cons_msg_acc_can       = 'Accepting Canceled';                                          
      sPSk_Cons_msg_unknown       = 'Unknown Error No. ';                                          
      sPSk_Cons_msg_elookup       = 'Looking Up Error Message';                              
      sPSk_Cons_msg_ttrig         = 'Timer Triggered';                                                
      sPSk_Cons_msg_TimerOn       = 'Timer On';                                                              
      sPSk_Cons_msg_TimerOff      = 'Timer Off';
      sPSk_Cons_msg_ClearInput    = 'Clearing Input';
      sPSk_Cons_msg_DataAvailable = 'Data Available';
      sPSk_Cons_msg_InitSock      = 'Initializing Winsock';                                      
      sPSk_Cons_msg_ReadToStr     = 'ReadToStream';                                                      
      sPSk_Cons_msg_WriteFrSt     = 'WriteFromStream';                                                
      sPSk_Cons_msg_RCloseSock    = 'Request Close Socket';                                      
      sPSk_Cons_msg_getLastE      = 'Getting LastError Number';                              
      sPSk_Cons_msg_setLastE      = 'Setting LastError Number';                              
      sPSk_Cons_msg_CheckE        = 'Checking Error In Error Manager';                
      sPSk_Cons_msg_SetSockE      = 'Setting Winsock Error';                                    
      sPSk_Cons_msg_ResolvHos     = 'Resolve Host';
      sPSk_Cons_msg_Abort         = 'Abort';
      sPSk_Cons_msg_CloseSock     = 'Closing Socket';
      sPSk_Cons_msg_GetLocalIP    = 'Getting Local IP';
      sPSk_Cons_msg_GetRemoteIP   = 'Getting Remote IP';
      sPSk_Cons_msg_NoTimer       = 'No Timer';                                                              
      sPSk_Cons_winfo_ver         = 'Version= ';                                                            
      sPSk_Cons_winfo_Hiver       = 'High Version= ';                                                  
      sPSk_Cons_winfo_Descr       = 'Description= ';                                                    
      sPSk_Cons_winfo_Sys         = 'System= ';                                                              
      sPSk_Cons_winfo_MaxSoc      = 'Max Sockets= ';                                                    
      sPSk_Cons_winfo_MaxUdp      = 'Max Udp pack size= ';                                        
      sPSk_Cons_winfo_Vend        = 'Vendor Information= ';                                      

implementation

end.
