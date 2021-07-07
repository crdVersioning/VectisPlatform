package com.dps.pods;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class ReplicaSynchronizer implements ServletContextListener
{
    @Override
    public void contextInitialized(ServletContextEvent event)
    {
        System.out.println("Vectis Platform : initializing context");
        System.out.println("Vectis Platform : context initialized");
    }

    @Override
    public void contextDestroyed(ServletContextEvent event)
    {
        System.out.println("Vectis Platform : destroying context");
        System.out.println("Vectis Platform : context destroyed");
    }
}
