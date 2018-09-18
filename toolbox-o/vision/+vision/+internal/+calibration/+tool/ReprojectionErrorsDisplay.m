classdef ReprojectionErrorsDisplay < vision.internal.uitools.AppFigure
    % ReprojectionErrorsDisplay encapsulates the reprojection errors figure for the
    % Camera Calibrator and the Stereo Camera Calibrator
    
    % Copyright 2014 The MathWorks, Inc.
    
    properties
        View = 'BarGraph';
        Axes = [];
        Tag = 'ReprojectionErrorsAxes';        
        ViewSwitchBtn;
        LegendPositionBar = [];
        LegendPositionScatter = [];
        IsViewChanged = false;
    end
    
    methods
        %------------------------------------------------------------------
        function this = ReprojectionErrorsDisplay()
            title = vision.getMessage('vision:caltool:ErrorsFigure');
            this = this@vision.internal.uitools.AppFigure(title);  
        end
        
        %------------------------------------------------------------------
        function createAxes(this)            
            this.Axes = axes('Parent', this.Fig,...
                'tag', this.Tag);
            
            % Create space between the axes and the switch button
            set(this.Axes, 'Position', [0.15, 0.2, 0.75, 0.72] );
        end
        
        %------------------------------------------------------------------
        function tf = isValidAxes(this)
            tf = ~(isempty(this.Axes) || ~ishandle(this.Axes));
        end

        %------------------------------------------------------------------
        function plot(this, cameraParams, highlightIndex, clickBarFcn, ...
                clickSelectedBarFcn)
            if ~ishandle(this.Axes)
                createAxes(this);
            end
            
            if ~this.IsViewChanged
                % If the view has changed, then legend position is already
                % saved. If we save it again it will be saved under the
                % wrong view.
                this.saveLegendPosition();
            end
            this.IsViewChanged = false;                        

            showReprojectionErrors(cameraParams, this.View, 'Parent', ...
                this.Axes, 'HighlightIndex', highlightIndex);
            set(this.Axes, 'Tag', this.Tag);
            
            this.restoreLegendPosition();
            
            % The title of the figure is set by showReprojectionErrors().
            % Setting it to empty, because it is redundant in the
            % context of the app.
            title(this.Axes, '');
            set(this.Fig, 'HandleVisibility', 'callback');
            
            setBarClickCallbacks(this, clickBarFcn, clickSelectedBarFcn)
        end
        
        %------------------------------------------------------------------
        function saveLegendPosition(this)
            hLegend = findobj(this.Fig, 'Type', 'Legend');
            if ishandle(hLegend)
                if strcmpi(this.View, 'BarGraph')
                    this.LegendPositionBar = get(hLegend, 'Position');
                else
                    this.LegendPositionScatter = get(hLegend, 'Position');
                end
            end
        end
        
        %------------------------------------------------------------------
        function restoreLegendPosition(this)
            hLegend = findobj(this.Fig, 'Type', 'Legend');
            if strcmpi(this.View, 'BarGraph') && ~isempty(this.LegendPositionBar)
                set(hLegend, 'Position', this.LegendPositionBar);
            elseif ~isempty(this.LegendPositionScatter)
                set(hLegend, 'Position', this.LegendPositionScatter);
            end
        end
        
        %------------------------------------------------------------------
        function addViewSwitchButton(this, plotBarFcn, plotScatterFcn)
            this.ViewSwitchBtn = vision.internal.calibration.tool.ToggleButton;
            this.ViewSwitchBtn.Parent = this.Fig;
            this.ViewSwitchBtn.UnpushedName = ...
                vision.getMessage('vision:caltool:ShowScatter');
            this.ViewSwitchBtn.UnpushedToolTip = ...
                vision.getMessage('vision:caltool:ShowScatterToolTip');
            this.ViewSwitchBtn.PushedName = ...
                vision.getMessage('vision:caltool:ShowBar');
            this.ViewSwitchBtn.PushedToolTip = ...
                vision.getMessage('vision:caltool:ShowBarToolTip');
            this.ViewSwitchBtn.Tag = 'ReprojectionErrorsButton';
            this.ViewSwitchBtn.Position = [5 5 130 20];
            this.ViewSwitchBtn.UnpushedFcn = plotBarFcn;
            this.ViewSwitchBtn.PushedFcn = plotScatterFcn;
            create(this.ViewSwitchBtn);
        end
        
        %------------------------------------------------------------------
        function switchView(this, newView)
            this.saveLegendPosition();
            this.View = newView;
            this.IsViewChanged = true;
        end
        
        %------------------------------------------------------------------
        function setBarClickCallbacks(this, clickBarFcn, clickSelectedBarFcn)
            
            % enable click-ability for the bar graph
            if strcmp(this.View, 'BarGraph')
                fig = this.Fig;
                hBar = findobj(fig, 'tag', 'errorBars');
                set (hBar,'buttondownfcn', clickBarFcn);
                hSelectedBar = findobj(fig, 'tag', 'highlightedBars');
                set(hSelectedBar, 'buttondownfcn', clickSelectedBarFcn);
            end
        end
        
        %------------------------------------------------------------------
        function [clickedIdx, selectionType] = getSelection(this, h)
            % return the index of the bar that was clicked
            pt = get(get(h, 'Parent'), 'CurrentPoint');
            pt = pt(1, 1);
            
            % find the bar whose center is nearest to the click point
            barCenters = get(h, 'XData');
            [~, clickedIdx] = min(abs(barCenters - pt));
            
            selectionType = get(this.Fig, 'SelectionType');
        end
    end
end