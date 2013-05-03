{application,idgaf,
    [{description,"My Awesome Web Framework"},
     {vsn,"0.0.1"},
     {modules,
         [idgaf_incoming_mail_controller,idgaf_outgoing_mail_controller,
          idgaf_main_controller,link_to_names,idgaf_view_lib_tags,
          idgaf_custom_filters,idgaf_custom_tags,idgaf_view_main_page_html,
          idgaf_view_main_index_html]},
     {registered,[]},
     {applications,[kernel,stdlib,crypto]},
     {env,
         [{test_modules,[]},
          {lib_modules,[]},
          {websocket_modules,[]},
          {mail_modules,
              [idgaf_incoming_mail_controller,idgaf_outgoing_mail_controller]},
          {controller_modules,[idgaf_main_controller]},
          {model_modules,[link_to_names]},
          {view_lib_tags_modules,[idgaf_view_lib_tags]},
          {view_lib_helper_modules,[idgaf_custom_filters,idgaf_custom_tags]},
          {view_modules,
              [idgaf_view_main_page_html,idgaf_view_main_index_html]}]}]}.