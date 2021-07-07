package com.dss.vectis;

import static com.dps.sync2.SyncDaemon.startTimer;
import static com.dps.sync2.SyncDaemon.stopTimer;
import java.util.Date;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class Application implements ServletContextListener
{
    @Override
    public void contextInitialized (ServletContextEvent event)
    {
        System.out.println(new Date()+" VECTIS PLATFORM CONTEXT INITIALIZING");
        startTimer(7,0,"MATTINA");
        startTimer(13,0,"PRANZO");
        System.out.println(new Date()+" VECTIS PLATFORM CONTEXT INITIALIZED");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce)
    {
        System.out.println(new Date()+" VECTIS PLATFORM CONTEXT DESTROYING");
        stopTimer("MATTINA");
        stopTimer("PRANZO");
        System.out.println(new Date()+" VECTIS PLATFORM CONTEXT DESTROYED");
    }
}
