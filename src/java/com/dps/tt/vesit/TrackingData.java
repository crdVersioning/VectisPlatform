package com.dps.tt.vesit;

import com.dps.tt.vesit.*;
import com.dps.dbi.DbResult;
import java.util.HashMap;
import java.util.Map;

public class TrackingData
{
    public DbResult deliveries_dbr;
    public DbResult anomalies_dbr;
    public final Map<Integer,String> states = new HashMap<>();
    public String regionPattern;
    
    public String errorMessage;
    public String exceptionMessage;

}
