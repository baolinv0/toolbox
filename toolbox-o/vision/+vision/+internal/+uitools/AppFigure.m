classdef AppFigure < handle
    % AppFigure Base class for figures used in a tool strip-based app.
    %
    %   fig = AppFigure(title) returns an AppFigure object representing a
    %   figure that can be dropped into a tool strip app. title is a string
    %   containing the figure title.
    %
    %   AppFigure properties:
    %     Fig   - The figure handle
    %     Title - The figure title
    %
    %   AppFigure methods:
    %     createFigure        - Create the figure
    %     wipeFigure          - Clear the figure
    %     makeFigureVisible   - Turn figure visibility on
    %     makeHandleVisible   - Turn figure handle visibility on
    %     makeHandleInvisible - Turn figure handle visibility off
    %     lockFigure          - Make the figure modifiable by callbacks only
    %     close               - Close the figure
    
    % Copyright 2014-2015 The MathWorks, Inc.
    
    properties
        %Fig The figure handle
        Fig = [];
        
        %Title The figure title
        Title;
    end
    
    methods
        %-------------------------------------------------------------------
        function this = AppFigure(title)
            this.Title = title;
            createFigure(this);
        end
        
        
        %------------------------------------------------------------------
        function createFigure(this)
            %createFigure Create the figure
            this.Fig = figure('Resize', 'off', 'Visible','off', ...
                'NumberTitle', 'off', 'Name', this.Title, 'HandleVisibility',...
                'callback', 'Color','white','IntegerHandle','off');
        end
        
        %------------------------------------------------------------------
        function wipeFigure(this)
            %wipeFigure Clear the figure
            if ishandle(this.Fig)
                set(this.Fig,'HandleVisibility','on');
                clf(this.Fig);
                set(this.Fig,'HandleVisibility','callback');
            end
        end
        
        %------------------------------------------------------------------
        function makeFigureVisible(this)
            %makeFigureVisible Turn figure handle visibility on
            set(this.Fig, 'Visible', 'on');
        end
        
        %------------------------------------------------------------------
        function makeHandleVisible(this)
            %makeHandleVisible Turn figure handle visibility on
            set(this.Fig,'HandleVisibility','on');
        end
        
        %------------------------------------------------------------------
        function makeHandleInvisible(this)
            %makeHandleInvisible Turn figure handle visibility off
            set(this.Fig,'HandleVisibility','off');
        end
        
        %------------------------------------------------------------------
        function lockFigure(this)
            %lockFigure Make the figure modifiable by callbacks only
            if ishandle(this.Fig)
                set(this.Fig,'HandleVisibility', 'callback');
            end
        end
        
        %------------------------------------------------------------------
        function close(this)
            %CLOSE Close the figure
            if ishandle(this.Fig)
                this.makeHandleVisible();
                delete(this.Fig);
            end
        end
    end
    
end