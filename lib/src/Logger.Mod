MODULE Logger;

(**This module provides a very simple but still powerful abstraction for
   logging policy, log messages, and log targets.

   It distingushes between two kinds of log messages:

   @table @asis
   @item Debug Messages
   The target audience of debug messages are people who know about the inner
   workings of the program or library---that is, developers.  As such, they are
   not for public consumption and developers have complete freedom where to
   output debug messages, and what to put into them.

   @item Report Messages
   Reports are intended for people who use or operate the application.  Their
   intention is usually to report on progress of the application, provide
   information on interaction with the outside world, and, most importantly, to
   communicate failures and the cause of the problem.  Report messages must be
   formulated in such a way that they can be understood and acted upon by
   non-developers.
   @end table

   Report logs and debug logs can be send to different targets.  A typical
   setup might forward reports to a remote logging service, while debug logs
   are only written to local files.  Examples for report messages: which config
   file is being read, whether the configuration has been processed
   successfully, or that an external database server has been connected to.
   All reports messages are duplicated into the debug log as well.  This means,
   that access to the debug log provides all the log messages of the
   application, in the order in which they were generated by the application.

   There are a number of issues that are not addressed by this module.  The
   application designer has to create his own policy regarding the following
   issues:

   @table @asis
   @item Logging by Functional Units
   This module does not provide and infrastructure to groups log messages by
   applications, components, modules, classes, or functions.  By using
   different log handles with distinct prefix strings, the developer can group
   messages by functional units.

   @item Severity Levels
   Beyond the basic distinction between report and debug messages, no further
   message classification is build in.  The reason for this is that there is no
   ``one size fits all'' severity classification.  And even there is an agreed
   baseline, it is very hard to use it consistently across applications, third
   party software, different developers, and so on.

   @item Usage of Log Handles
   There is no predisposition on how log handles are used in applications,
   libraries, or modules.  In some situations, a single log handle stored in a
   global public variable may be sufficient.  Other designs may prefer to use
   separate handles for functional units.
   @end table  *)

IMPORT
  Object, IO, IO:TextRider, IO:StdChannels, Object:Boxed, Logger:TimeStamp;
  
TYPE
  Target* = POINTER TO TargetDesc;
  TargetDesc = RECORD [ABSTRACT]
    (**A log target is the destination of log messages from the point of view
       of the application (or thread).  The class @otype{Target} has a
       number of responsibilities:

       @enumerate
       @item
       Pass the message on to the log destination.  This can be a file, a local
       service, a remote service, @file{/dev/null}, or a combination thereof.

       @item
       Attach time stamps to log messages if required.

       @item
       Sanitize content of log messages.  If the log destination only accepts a
       single line per log entry, then it must remove all end of line
       characters.  If the destination has a limit in the number of characters
       per log entry, then it must truncate entries accordingly.  If it may
       interpret certain character combinations as commands (for example, when
       displaying a log in a terminal), then it must eliminate all
       ``dangerous'' characters.

       @item
       It must handle any character encoding mismatch between an application's
       log messages and the log destination.

       @item
       It must be able to deal with multiple sources of input, possibly running
       concurrently in multiple threads.

       @item
       It must perform any logging related bookkeeping.  A typical example for
       this is log file rotation for long running applications.
       @end enumerate  *)
    passOnReport-: BOOLEAN;
    (**Global flag to disable all report output send to this target.  The flag
       is tested by the @otype{Handle} implementations.  *)
    passOnDebug-: BOOLEAN;
    (**Global flag to disable all debug output send to this target.  The flag
       is tested by the @otype{Handle} implementations.  *)
  END;
  
TYPE
  NullTarget = POINTER TO NullTargetDesc;
  NullTargetDesc = RECORD
    (TargetDesc) 
  END;
  
TYPE
  ChannelTarget = POINTER TO ChannelTargetDesc;
  ChannelTargetDesc = RECORD
    (TargetDesc)
    writer: TextRider.Writer;
  END;
  
TYPE
  Handle* = POINTER TO HandleDesc;
  HandleDesc = RECORD
    reportTarget-: Target;
    debugTarget-: Target;
    prefix-, prefixReportInDebug: STRING;
    enableReport-: BOOLEAN;
    enableDebug-: BOOLEAN;
  END;

CONST
  timeStampFormat* = "%d %b %H:%M:%S ";

VAR
  nullTarget-, stderrTarget-, stdoutTarget-: Target;
  nullHandle-: Handle;
  
PROCEDURE (lt: Target) INIT*(passOnReport, passOnDebug: BOOLEAN);
  BEGIN
    lt.passOnReport := passOnReport;
    lt.passOnDebug := passOnDebug;
  END INIT;
  
PROCEDURE (lt: Target) [ABSTRACT] Write*(prefix, msg: STRING);
  END Write;

PROCEDURE (lt: NullTarget) INIT*();
  BEGIN
    lt.INIT^(FALSE, FALSE);
  END INIT;
  
PROCEDURE (lt: NullTarget) Write*(prefix, msg: STRING);
  BEGIN
    (* nothing *)
  END Write;

PROCEDURE (lt: ChannelTarget) INIT*(passOnReport, passOnDebug: BOOLEAN;
                                    ch: IO.ByteChannel);
  BEGIN
    lt.INIT^(passOnReport, passOnReport);
    lt.writer := TextRider.ConnectWriter(ch);
  END INIT;
  
PROCEDURE (lt: ChannelTarget) Write*(prefix, msg: STRING);
  VAR
    str: ARRAY 64 OF CHAR;
  BEGIN
    TimeStamp.LocalNow(str, timeStampFormat);
    lt.writer.WriteString(str);
    
    (* FIXME... remove control and non-latin1 characters *)
    lt.writer.WriteObject(prefix+msg);
    lt.writer.WriteLn;
  END Write;

  (* ---------------------------------------------------------------------- *)
  
PROCEDURE (lh: Handle) INIT*(reportTarget, debugTarget: Target;
                             prefix: STRING);
  BEGIN
    lh.reportTarget := reportTarget;
    lh.enableReport := (reportTarget # nullTarget);
    lh.debugTarget := debugTarget;
    lh.enableDebug := (debugTarget # nullTarget);
    IF (prefix = NIL) THEN
      lh.prefix := "";
    ELSE
      lh.prefix := prefix;
    END;
    lh.prefixReportInDebug := lh.prefix+"REPORT: ";
  END INIT;

PROCEDURE (lh: Handle) EnableReport*(enable: BOOLEAN);
  BEGIN
    lh.enableReport := enable;
  END EnableReport;
  
PROCEDURE (lh: Handle) EnableDebug*(enable: BOOLEAN);
  BEGIN
    lh.enableDebug := enable;
  END EnableDebug;
  
PROCEDURE (lh: Handle) CloneTargets*(newPrefix: STRING): Handle;
  VAR
    copy: Handle;
  BEGIN
    copy := NEW(Handle, lh.reportTarget, lh.debugTarget, newPrefix);
    copy.enableReport := lh.enableReport;
    copy.enableDebug := lh.enableDebug;
    RETURN copy;
  END CloneTargets;
  
PROCEDURE (lh: Handle) Debug*(msg: STRING);
  BEGIN
    IF lh.enableDebug & lh.debugTarget.passOnDebug THEN
      lh.debugTarget.Write(lh.prefix, msg);
    END;
  END Debug;
  
PROCEDURE (lh: Handle) DebugObject*(msg: STRING; x: Object.Object);
  VAR
    str: STRING;
  BEGIN
    IF (x = NIL) THEN
      str := "<NIL>";
    ELSE
      str := x.ToString();
    END;
    lh.Debug(msg+": "+str);
  END DebugObject;

PROCEDURE (lh: Handle) DebugInt*(msg: STRING; x: LONGINT);
  BEGIN
    lh.Debug(msg+": "+Boxed.IntToString(x));
  END DebugInt;

PROCEDURE (lh: Handle) DebugBool*(msg: STRING; x: BOOLEAN);
  BEGIN
    lh.Debug(msg+": "+Boxed.BooleanToString(x));
  END DebugBool;
  
PROCEDURE (lh: Handle) DebugLongReal*(msg: STRING; x: LONGREAL);
  BEGIN
    lh.Debug(msg+": "+Boxed.LongRealToString(x));
  END DebugLongReal;
  
PROCEDURE (lh: Handle) Report*(msg: STRING);
(**Report messages are also duplicated into the debug log.  *)
  BEGIN
    IF lh.enableDebug & lh.debugTarget.passOnDebug THEN
      lh.debugTarget.Write(lh.prefixReportInDebug, msg);
    END;
    IF lh.enableReport & lh.reportTarget.passOnReport THEN
      lh.reportTarget.Write(lh.prefix, msg);
    END;
  END Report;

PROCEDURE (lh: Handle) ReportObject*(msg: STRING; x: Object.Object);
  VAR
    str: STRING;
  BEGIN
    IF (x = NIL) THEN
      str := "<NIL>";
    ELSE
      str := x.ToString();
    END;
    lh.Report(msg+": "+str);
  END ReportObject;

PROCEDURE (lh: Handle) ReportInt*(msg: STRING; x: LONGINT);
  BEGIN
    lh.Report(msg+": "+Boxed.IntToString(x));
  END ReportInt;

PROCEDURE (lh: Handle) ReportBool*(msg: STRING; x: BOOLEAN);
  BEGIN
    lh.Report(msg+": "+Boxed.BooleanToString(x));
  END ReportBool;
  
PROCEDURE (lh: Handle) ReportLongReal*(msg: STRING; x: LONGREAL);
  BEGIN
    lh.Report(msg+": "+Boxed.LongRealToString(x));
  END ReportLongReal;
  
BEGIN
  nullTarget := NEW(NullTarget);
  nullHandle := NEW(Handle, nullTarget, nullTarget, NIL);
  stderrTarget := NEW(ChannelTarget, TRUE, TRUE, StdChannels.stderr);
  stdoutTarget := NEW(ChannelTarget, TRUE, TRUE, StdChannels.stdout);
END Logger.
