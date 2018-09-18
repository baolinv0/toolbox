% Copyright 2014 The MathWorks, Inc.

classdef ExportDlg < vision.internal.uitools.OkCancelDlg
    properties
        VarName;
    end
    
    properties(Access=private)
        Prompt;        
        EditBox;
        
        PromptX = 10;
        EditBoxX = 207;
    end
    
    methods
        %------------------------------------------------------------------
        function this = ExportDlg(groupName, paramsPrompt, paramsVarName)
            dlgTitle = vision.getMessage('vision:uitools:ExportTitle');
            this = this@vision.internal.uitools.OkCancelDlg(...
                groupName, dlgTitle);
            
            this.VarName = paramsVarName;            
            this.Prompt = paramsPrompt;
            
            this.DlgSize = [400, 90];
            createDialog(this);
            
            addParamsVarPrompt(this);            
            addParamsVarEditBox(this);
        end
    end
    
    methods(Access=private)
        %------------------------------------------------------------------
        function addParamsVarPrompt(this)
            % Prompt
            uicontrol('Parent',this.Dlg,'Style','text',...
                'Position',[this.PromptX, 48, 200, 20], ...
                'HorizontalAlignment', 'left',...
                'String', this.Prompt);                
        end
        
        %------------------------------------------------------------------
        function addParamsVarEditBox(this)
            this.EditBox = uicontrol('Parent', this.Dlg,'Style','edit',...
                'String',this.VarName,...
                'Position', [this.EditBoxX, 47, 180, 25],...
                'HorizontalAlignment', 'left',...
                'BackgroundColor',[1 1 1], ...
                'Tag', 'varEditBox',...
                'ToolTipString', ...
                vision.getMessage('vision:caltool:ExportParametersNameToolTip'));
        end        
    end
    
    methods(Access=protected)
        %------------------------------------------------------------------
        function onOK(this, ~, ~)
            this.VarName = get(this.EditBox, 'String');
            if ~isvarname(this.VarName)
                errordlg(getString(message('vision:uitools:invalidExportVariable')));
            else
                this.IsCanceled = false;
                close(this);
            end
        end
    end
end