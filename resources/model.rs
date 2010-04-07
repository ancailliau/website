people                   AcmScW.database[:people]
activities               AcmScW.database[:activities]
planned_events           AcmScW.database[:events].filter(:status => 'planned')
olympiades_registrations AcmScW.database[:olympiades_registrations]
olympiades_results       AcmScW.database[:olympiades_results]