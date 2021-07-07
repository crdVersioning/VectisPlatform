package com.dps.tt.cedi;

import com.dps.dbi.DbResult.Record;
import com.dps.dbi.impl.SqlServerInterface;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DAO
{    
    private static final SimpleDateFormat SDF = new SimpleDateFormat("yyyy-MM-dd");
    private static String NULLDATE = "1900-01-01";

    public static TrackingData readTrackingData(Date fromDate, Date toDate, String region)
    {
        TrackingData td = new TrackingData();

        if(region.isEmpty()) region = null;
        if(region!=null) td.regionPattern = region.replaceAll("[^A-Z]","%");
                
        // ACCESSO AL DATABASE
        SqlServerInterface dbi = new SqlServerInterface().name("WebFolder").username("sa").password("4lp4c1n0");

        // CARICAMENTO DELLE SPEDIZIONI E DELLE ANOMALIE
        try
        {
            td.deliveries_dbr = dbi.read("replica.view_Shipments_CEDI").top(1000)
                .andIsLike(region!=null&&!region.isEmpty(),"deliveryRegion",td.regionPattern)
                .andIsNotLess(fromDate!=null,"chargeDate",fromDate)
                .andIsNotGreater(toDate!=null,"chargeDate",toDate)
                .go();

            td.anomalies_dbr = dbi.read("replica.view_Anomalies")
                .isIn("delivery_key",td.deliveries_dbr.getColumnData("delivery_key"))
                .order("date").go();

            td.deliveries_dbr.addSubResultSet(td.anomalies_dbr,"anomalies","delivery_key",Integer.class);
        }
        catch(Exception ex)
        {
            td.errorMessage = "ERRORE DI SISTEMA";
            td.exceptionMessage = ex.toString();
        }


        // IDENTIFICAZIONE DEGLI STATI


        for(Record delivery : td.deliveries_dbr)
        {
            Date travelDate = delivery.getDate("travelDate");
            Date deliveryDate = delivery.getDate("deliveryDate");
            Date today = new Date();
            long oneDay = 24*60*60*1000;

            String status = "-";

            if(travelDate==null) status = "IN PROGRAMMAZIONE";
            else if(deliveryDate!=null && !NULLDATE.equals(SDF.format(deliveryDate))) status = "CONSEGNATO IL "+SDF.format(deliveryDate);
            else
            {
                if(delivery.getString("deliveryRegion")!=null) switch(delivery.getString("deliveryRegion").toUpperCase())
                {
                    case "CAMPANIA": break;

                    case "SICILIA": case "SARDEGNA":
                        status = (today.getTime()-travelDate.getTime()>=2*oneDay) ?
                            "ARRIVATO IN PIATTAFORMA : "+SDF.format(new Date(travelDate.getTime()+2*oneDay)) :
                            "IN TRANSITO";
                        break;

                    default:
                        status = (today.getTime()-travelDate.getTime()>=oneDay) ?
                            "ARRIVATO IN PIATTAFORMA : "+SDF.format(new Date(travelDate.getTime()+oneDay)) :
                            "IN TRANSITO";
                }
            }    

            td.states.put(delivery.getInteger("delivery_key"),status);
        }
        
        return td;
    }
}
