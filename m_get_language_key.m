function [ keys ] = m_get_language_key( ext )
% DEFINES VALUE FOR THE ASSOCIATED KEYWORDS
% INPUT  : file_content (cell array)
% OUTPUT : lan (structure)

%  Created by Marc Benoit for Zonge International on Aug/31/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

keys=[];
feature('DefaultCharacterSet', 'UTF8');

% GET CONTENT
file_content=l_get_file_content( ext );

%if ~isempty(file_content)
    

    keys.delete_file=l_search_key('$delete_file',file_content,ext);
    keys.copy_file=l_search_key('$copy_file',file_content,ext);
    keys.data_look=l_search_key('$data_look',file_content,ext);
    
    
    % READ FILES
    keys.read_file_err1=l_search_key('$read_file_err1',file_content,ext);
    keys.read_file_err2=l_search_key('$read_file_err2',file_content,ext);
    keys.read_file_err3=l_search_key('$read_file_err3',file_content,ext);
    keys.read_file_err4=l_search_key('$read_file_err4',file_content,ext);
    keys.read_file_err5=l_search_key('$read_file_err5',file_content,ext);
    keys.read_file_err6=l_search_key('$read_file_err6',file_content,ext);
    
    %% SCHEDULE
    keys.ZenSCH_err1=l_search_key('$ZenSCH_err1',file_content,ext);
    keys.ZenSCH_err2=l_search_key('$ZenSCH_err2',file_content,ext);
    keys.ZenSCH_err3=l_search_key('$ZenSCH_err3',file_content,ext);
    keys.ZenSCH_err4=l_search_key('$ZenSCH_err4',file_content,ext);
    keys.ZenSCH_err5=l_search_key('$ZenSCH_err5',file_content,ext);
    keys.ZenSCH_err6=l_search_key('$ZenSCH_err6',file_content,ext);
    keys.ZenSCH_err7=l_search_key('$ZenSCH_err7',file_content,ext);
    keys.ZenSCH_err8=l_search_key('$ZenSCH_err8',file_content,ext);
    
    %% ZENACQ graphic
    keys.Receiver_str=l_search_key('$Receiver_str',file_content,ext);
    keys.Transmitter_str=l_search_key('$Transmitter_str',file_content,ext);
    keys.Data_transfer_str=l_search_key('$Data_transfer_str',file_content,ext);
    keys.Calibration_str=l_search_key('$Calibration_str',file_content,ext);
    keys.Settings_str=l_search_key('$Settings_str',file_content,ext);
    keys.Options_str=l_search_key('$Options_str',file_content,ext);
    keys.channel_str_plurial=l_search_key('$channel_str_plurial',file_content,ext);
    keys.ZenACQ_err1=l_search_key('$ZenACQ_err1',file_content,ext);
    
    
    %%ZenACQ timer
    keys.channel_str=l_search_key('$channel_str',file_content,ext);
    keys.ZenACQ_info_msg1=l_search_key('$ZenACQ_info_msg1',file_content,ext);
    keys.ZenACQ_info_msg2=l_search_key('$ZenACQ_info_msg2',file_content,ext);

    
    %% ZEN RX
    
    keys.box_str=l_search_key('$box_str',file_content,ext);
    keys.status_channel_str=l_search_key('$status_channel_str',file_content,ext);
    keys.status_sats_str=l_search_key('$status_sats_str',file_content,ext);
    keys.status_sync_str=l_search_key('$status_sync_str',file_content,ext);
    
    keys.general_info_panel_str=l_search_key('$general_info_panel_str',file_content,ext);
    keys.job_name_str=l_search_key('$job_name_str',file_content,ext);
    keys.job_number_str=l_search_key('$job_number_str',file_content,ext);
    keys.job_by_str=l_search_key('$job_by_str',file_content,ext);
    keys.job_for_str=l_search_key('$job_for_str',file_content,ext);
    keys.operator_str=l_search_key('$operator_str',file_content,ext);
    
    keys.schedule_panel_str=l_search_key('$schedule_panel_str',file_content,ext);
    keys.new_push_str=l_search_key('$new_push_str',file_content,ext);
    keys.edit_push_str=l_search_key('$edit_push_str',file_content,ext);
    keys.start_time_str=l_search_key('$start_time_str',file_content,ext);
    keys.end_time_str=l_search_key('$end_time_str',file_content,ext);
    keys.data_push_str=l_search_key('$data_push_str',file_content,ext);
    
    keys.survey_panel_str=l_search_key('$survey_panel_str',file_content,ext);
    keys.stn_str=l_search_key('$stn_str',file_content,ext);
    keys.line_str=l_search_key('$line_str',file_content,ext);
    keys.SX_azimuth_str=l_search_key('$SX_azimuth_str',file_content,ext);
    keys.a_space_str=l_search_key('$a_space_str',file_content,ext);
    keys.s_space_str=l_search_key('$s_space_str',file_content,ext);
    keys.z_positive_str=l_search_key('$z_positive_str',file_content,ext);
    keys.save_push_str=l_search_key('$save_push_str',file_content,ext);
    keys.check_setup_str=l_search_key('$check_setup_str',file_content,ext);

    keys.set_up_str=l_search_key('$set_up_str',file_content,ext);
    keys.set_up_transmit_str=l_search_key('$set_up_transmit_str',file_content,ext);
    keys.version_str=l_search_key('$version_str',file_content,ext);
    keys.gps_time_str=l_search_key('$gps_time_str',file_content,ext);
    keys.status_volts_str=l_search_key('$status_volts_str',file_content,ext);
    keys.zen_zone_str=l_search_key('$zen_zone_str',file_content,ext);
    keys.zen_altitude=l_search_key('$zen_altitude',file_content,ext);
    keys.transmit_msg=l_search_key('$transmit_msg',file_content,ext);
    
    
    % ZENRX timer
    keys.time_zone_err1=l_search_key('$time_zone_err1',file_content,ext);
    keys.time_zone_err2=l_search_key('$time_zone_err2',file_content,ext);
    keys.timer_msg1=l_search_key('$timer_msg1',file_content,ext);
    keys.timer_msg2=l_search_key('$timer_msg2',file_content,ext);
    keys.timer_msg3=l_search_key('$timer_msg3',file_content,ext);
    
    % Version
    keys.version_err1=l_search_key('$version_err1',file_content,ext);
    keys.version_err2=l_search_key('$version_err2',file_content,ext);
    keys.ZenTitle=l_search_key('$ZenTitle',file_content,ext);
    keys.ZenTitle2=l_search_key('$ZenTitle2',file_content,ext);
    keys.yes=l_search_key('$yes',file_content,ext);
    keys.no=l_search_key('$no',file_content,ext);
    
    % CHECK AUTO INPUT
    keys.input_err1=l_search_key('$input_err1',file_content,ext);
    keys.input_err2=l_search_key('$input_err2',file_content,ext);
    keys.input_err3=l_search_key('$input_err3',file_content,ext);
    keys.input_err4=l_search_key('$input_err4',file_content,ext);
    
    % COMMIT CHECK INPUT
    keys.commit_msg1=l_search_key('$commit_msg1',file_content,ext);
    keys.commit_msg2=l_search_key('$commit_msg2',file_content,ext);
    keys.commit_msg3=l_search_key('$commit_msg3',file_content,ext);
    keys.commit_msg4=l_search_key('$commit_msg4',file_content,ext);
    keys.commit_msg5=l_search_key('$commit_msg5',file_content,ext);
    keys.commit_msg6=l_search_key('$commit_msg6',file_content,ext);
    keys.commit_msg7=l_search_key('$commit_msg7',file_content,ext);
    keys.commit_msg8=l_search_key('$commit_msg8',file_content,ext);
    
    
    % PROGRESS BAR
    keys.progress_title1=l_search_key('$progress_title1',file_content,ext);
    keys.progress_title2=l_search_key('$progress_title2',file_content,ext);
    keys.progress_title3=l_search_key('$progress_title3',file_content,ext);
    keys.progress_title4=l_search_key('$progress_title4',file_content,ext);
    keys.progress_title5=l_search_key('$progress_title5',file_content,ext);
    keys.progress_title6=l_search_key('$progress_title6',file_content,ext);
    
    keys.progress_str1=l_search_key('$progress_str1',file_content,ext);
    keys.progress_str2=l_search_key('$progress_str2',file_content,ext);
    keys.progress_str3=l_search_key('$progress_str3',file_content,ext);
    keys.progress_str4=l_search_key('$progress_str4',file_content,ext);
    keys.progress_str5=l_search_key('$progress_str5',file_content,ext);
    keys.progress_str6=l_search_key('$progress_str6',file_content,ext);
    keys.progress_str7=l_search_key('$progress_str7',file_content,ext);
    keys.progress_str8=l_search_key('$progress_str8',file_content,ext);
    
    keys.sync_err1=l_search_key('$sync_err1',file_content,ext);
    keys.sync_err2=l_search_key('$sync_err2',file_content,ext);
    keys.sync_err3=l_search_key('$sync_err3',file_content,ext);
    keys.calibration_msg1=l_search_key('$calibration_msg1',file_content,ext);

    % DATA TRANSFERT
    keys.data_transfer_msg1=l_search_key('$data_transfer_msg1',file_content,ext);
    keys.data_transfer_msg2=l_search_key('$data_transfer_msg2',file_content,ext);
    keys.data_transfer_msg3=l_search_key('$data_transfer_msg3',file_content,ext);
    
    % SETTINGS
    keys.zenACQ_mode_str=l_search_key('$zenACQ_mode_str',file_content,ext);
    keys.time_zone_str=l_search_key('$time_zone_str',file_content,ext);
    keys.example_str=l_search_key('$example_str',file_content,ext);
    keys.storage_location_str=l_search_key('$storage_location_str',file_content,ext);
    keys.get_folder_push_str=l_search_key('$get_folder_push_str',file_content,ext);
    keys.save_push_str=l_search_key('$save_push_str',file_content,ext);
    
    
    
    
   
    

end