function internalCustomizationVision( obj )
% Copyright 2014 The MathWorks, Inc.
    
    if dig.isProductInstalled( 'Computer Vision System Toolbox', 'Video_and_Image_Blockset' )   
        im = DAS.InterfaceManager.getApplicationIM( 'Simulink' );       
        if ~isempty( im )
            feature( 'scopedAccelEnablement', 'off' );
            % add Actions
            im.addAction( 'Simulink:MPlayVideoViewer', @MPlayVideoViewer, ...
                          {}, { 'Simulink:Model' } );
        end
        
        cm = obj.CustomizationManager; 
        if ~ispc    
            cm.addSigScopeMgrViewerLibrary('vipviewers_all');
        else
            cm.addSigScopeMgrViewerLibrary('vipviewers_win32');
        end
          
        cm.addSigScopeMgrGeneratorLibrary( 'vipgenerators_all' );
    end
end

%-----------------------------------------------------------------------------
function schema = MPlayVideoViewer( ~ ) % ( cbinfo )
    schema          = sl_action_schema;
    schema.tag      = 'Simulink:MPlayVideoViewer';
    schema.label    = DAStudio.message( 'Simulink:studio:MPlayVideoViewer' );
    schema.callback = @MPlayVideoViewerCB;
    schema.autoDisableWhen = 'Busy';
end

%-----------------------------------------------------------------------------
function MPlayVideoViewerCB( ~ ) % ( cbinfo )
    implay;
end
