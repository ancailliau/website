people                   AcmScW.database[:people]
activities               AcmScW.database[:activities]
planned_events           AcmScW.database[:events].filter(:status => 'planned')
olympiades_registrations AcmScW.database[:olympiades_registrations]
olympiades_results_sec   AcmScW.database[:olympiades_results].filter(:cat => '1').filter(:selectionne => 'true').order(:nom)
olympiades_results_sup   AcmScW.database[:olympiades_results].filter(:cat => '2').filter(:selectionne => 'true').order(:nom)