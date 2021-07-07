package com.dps.sync2;

import com.dps.dbi.impl.SqlServerInterface;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SyncDaemon 
{
    public static final long A_DAY = 24*60*60*1000L;
    public static Map<String,Timer> timers = new LinkedHashMap<>();
    
    public static final SqlServerInterface DELMATE = new SqlServerInterface()
        .address("192.168.0.140").out(null)
        .name("DelMate").username("sa").password("4lp4c1n0");

    public static final SqlServerInterface DIGINVOICE = new SqlServerInterface()
        .address("192.168.0.140").out(null)
        .name("Diginvoice").username("sa").password("4lp4c1n0");

    public static final SqlServerInterface WEBFOLDER = new SqlServerInterface()
        .address("192.168.0.140").out(null)
        .name("WebFolder").username("sa").password("4lp4c1n0");

    
    public static void stopTimer(String tag)
    {
        timers.remove(tag).cancel();
    }
    
    public static void startTimer(int hour, int minute, String tag)
    {
        Calendar today = new GregorianCalendar();
        today.add(Calendar.DATE,1);
        today.set(Calendar.HOUR_OF_DAY,hour);
        today.set(Calendar.MINUTE,minute);
        today.set(Calendar.SECOND,0);

        Timer timer = new Timer();
        
        timer.scheduleAtFixedRate(new Syncronization(),today.getTime(),A_DAY);

        timers.put(tag,timer);
    }
    
    public static class Syncronization extends TimerTask
    {
        @Override
        public void run()
        {
            System.out.println(new Date()+" START DELMATE SYNC");

            try{DELMATE.execAndCheck("EXEC [dbo].[sp_SyncFromShowTrip]");}
            catch (SQLException ex) {Logger.getLogger(SyncDaemon.class.getName()).log(Level.SEVERE, null, ex);}

            System.out.println(new Date()+" START DELMATE ADDBORDEREAU");

            try{DELMATE.execAndCheck("EXEC [dbo].[sp_AddBordereau]");}
            catch (SQLException ex) {Logger.getLogger(SyncDaemon.class.getName()).log(Level.SEVERE, null, ex);}

            System.out.println(new Date()+" START DIGINVOICE SYNC");

            try{DIGINVOICE.execAndCheck("EXEC [dbo].[sp_ImportDeliveriesFromShowTrip_V2] @daysBack = 90");}
            catch (SQLException ex) {Logger.getLogger(SyncDaemon.class.getName()).log(Level.SEVERE, null, ex);}

            System.out.println(new Date()+" START WEBFOLDER SYNC");

            try{WEBFOLDER.execAndCheck("EXEC [dbo].[sp_SyncFromShowTrip]");}
            catch (SQLException ex) {Logger.getLogger(SyncDaemon.class.getName()).log(Level.SEVERE, null, ex);}

            System.out.println(new Date()+" END SYNC");
        }
    }

    public static void main(String[] args) 
    {
        new Syncronization().run();
        startTimer(7,0,"MATTINA");
        startTimer(13,0,"PRANZO");
    }

}
