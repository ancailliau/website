people                   AcmScW.database[:people]
activities               AcmScW.database[:activities]
events                   AcmScW.database[:events]
planned_events           AcmScW.database[:events].filter(:status => 'planned')
olympiades_registrations AcmScW.database[:olympiades_registrations]
olympiades_results       AcmScW.database[:olympiades_results]
olympiades_results_sec   AcmScW.database[:olympiades_results].filter(:cat => '1').filter(:selectionne => 'true').order(:nom)
olympiades_results_sup   AcmScW.database[:olympiades_results].filter(:cat => '2').filter(:selectionne => 'true').order(:nom)
webr_past_events         AcmScW.database[:webr_past_events]
webr_planned_events      AcmScW.database[:webr_planned_events]