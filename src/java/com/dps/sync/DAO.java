package com.dps.sync;

import com.dps.dbi.DbResult;
import com.dps.dbi.DbResult.Record;
import com.dps.dbi.impl.SqlServerInterface;
import java.util.Date;
import java.util.List;

public class DAO 
{
    public static final String SYNC_LOG_VIEW = "log_Syncronization";
    
    public static final SqlServerInterface REPLICA_DBI = new SqlServerInterface()
        .name("REPLICA").username("sa").password("4lp4c1n0");

    public static DbResult readLog()
    {
        return REPLICA_DBI.read(SYNC_LOG_VIEW).order("log_id DESC").go(ex->{throw new RuntimeException(ex);});
    }
    
    public static String resultLabel(List<String> tables, Record log)
    {
        try
        {
            return tables.stream()
                .map(table->log.getBoolean("result_"+table))
                .reduce(true,(x,y)->x&y) ?
                "Success" : "Fail";
        }
        catch(NullPointerException ex)
        {
            return "Null";
        }
    }

    public static String resultLabel(String table, Record log)
    {
        return log.getBoolean("result_"+table)!=null ?
            (log.getBoolean("result_"+table) ? "Success" : "Fail") :
            "Null";
    }

    public static Date startTimestamp(List<String> tables, Record log)
    {
        return log.getDate("start_"+tables.get(0));
    }

    public static Date stopTimestamp(List<String> tables, Record log)
    {
        return log.getDate("stop_"+tables.get(tables.size()-1));
    }

    public static String elapsed(List<String> tables, Record log)
    {
        String elapsed = "-";
        try
        {
            Long elapsedMsec = stopTimestamp(tables,log).getTime() - startTimestamp(tables,log).getTime();
            elapsed = (elapsedMsec/1000)/60+" min "+(elapsedMsec/1000)%60+" sec";
        }
        catch(Exception ex){}
        
        return elapsed;
    }

    public static String elapsed(String table, Record log)
    {
        try
        {
            Long elapsedMsec = log.getDate("stop_"+table).getTime() - log.getDate("start_"+table).getTime();
            return (elapsedMsec/1000)/60+" min "+(elapsedMsec/1000)%60+" sec";
        }
        catch(Exception ex)
        {
            return "-";
        }
    }
}
