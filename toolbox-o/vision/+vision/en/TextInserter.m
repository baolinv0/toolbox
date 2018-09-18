classdef TextInserter
%TextInserter Draw text on image or video stream
%   Use vision.TextInserter for code generation or when you need to process
%   fixed-point data. For all other applications, use the insertText
%   function.
%
%   The TextInserter System object draws text in an image. The output
%   image can then be displayed or saved to a file. It can draw arbitrary
%   ASCII string(s) at one or more locations in an image.
%  
%   txtInserter = vision.TextInserter('string') returns a text inserter
%   object, txtInserter. Invoking this object's step method, described
%   below, adds the text in the quotes to an image. The location of where
%   the text is inserted, font style and other text characteristics are
%   determined by the properties described below.
% 
%   txtInserter = vision.TextInserter(...,'Name', 'Value') configures the
%   text inserter properties, specified as one or more name-value pair
%   arguments. Unspecified properties have default values.
%
%   Step method syntax:
%
%   J = step(txtInserter, I) draws the string specified in Text property
%   onto image I and returns the result in image J. I can be a 2-D
%   grayscale image or a truecolor RGB image.
%
%   J = step(txtInserter, I, LOC) places the text at the [x y] 
%   coordinates specified by LOC, when the LocationSource property is 
%   'Input port'.
%
%   J = step(txtInserter, I, VARS) uses the data in VARS for variable
%   substitution, when the Text property contains ANSI C printf-style
%   format specifications (%d, %.2f, etc.). VARS is a scalar or a vector
%   having length equal to the number of format specifiers in each element
%   of the text string in Text property.
%
%   J = step(txtInserter, I, cellIdx) draws the text string selected
%   by index, cellIdx, when the Text property is a cell array of strings.
%   For example, when Text property is {'str1','str2'}, and cellIdx = 1, 
%   'str1' will be drawn in the image. Values of cellIdx, outside of valid
%   range result in no text drawn in the image.
%
%   J = step(txtInserter, I, COLOR) uses a scalar or a 3-element
%   vector, COLOR, for the text color. This option is available when the 
%   ColorSource property is 'Input port'.
%
%   J = step(txtInserter, I, OPAC) uses OPAC for the text opacity when
%   the OpacitySource property is set to 'Input port'.
%
%   The above operations can be used simultaneously, provided the object
%   properties are set appropriately. For example,
%       J = step(txtInserter, I, CELLIDX, VARS, COLOR, LOC, OPAC) 
%   draws the specified text onto image I using text selected by 
%   index CELLIDX, text variable substitution data VARS, color value COLOR
%   at location LOC with opacity OPAC.
%
%   TextInserter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create text inserter object with same property values
%   isLocked - Locked status (logical)
%
%   TextInserter properties:
%
%   Text            - Text string to draw on image or video stream
%   ColorSource     - Source of intensity or color of text
%   Color           - Intensity or color of text
%   LocationSource  - Source of text location
%   Location        - Top-left corner of text bounding box
%   OpacitySource   - Source of opacity of text
%   Opacity         - Opacity of text
%   TransposedInput - Specifies if input image data order is row major
%   Font            - Font face of text
%   FontSize        - Font size in points
%   Antialiasing    - Smooth text edges
%
%   EXAMPLE 1: Display a text string in an image
%   --------------------------------------------
%   textColor    = [255, 255, 255]; % [red, green, blue]
%   textLocation = [100 315];       % [x y] coordinates
%   textInserter = vision.TextInserter('Peppers are good for you!', ...);
%      'Color', textColor, 'FontSize', 24, 'Location', textLocation);
%
%   I = imread('peppers.png');
%   J = step(textInserter, I);
%   imshow(J);
%
%   EXAMPLE 2: Display four numeric values at different locations
%   -------------------------------------------------------------
%   textInserter = vision.TextInserter('%d', 'LocationSource', ...
%      'Input port', 'Color',  [255, 255, 255], 'FontSize', 24);
%
%   I = imread('peppers.png');
%   J = step(textInserter, I, int32([1 2 3 4]), ...
%            int32([1 1; 500 1; 1 350; 500 350]));
%   imshow(J);
%
%   EXAMPLE 3: Display two strings at different locations
%   -----------------------------------------------------
%   textInserter = vision.TextInserter('%s', 'LocationSource', ...
%      'Input port', 'Color',  [255, 255, 255], 'FontSize', 24);
%
%   I = imread('peppers.png');
%   % create null separated strings
%   strings = uint8(['left' 0 'right']); 
%   J = step(textInserter, I, strings, int32([10 1; 450 1]));
%   imshow(J);
%
%   See also insertText, insertShape, insertMarker, insertObjectAnnotation,
%      vision.AlphaBlender

 
%   Copyright 2004-2012 The MathWorks, Inc.

    methods
        function out=TextInserter
            %TextInserter Draw text on image or video stream
            %   Use vision.TextInserter for code generation or when you need to process
            %   fixed-point data. For all other applications, use the insertText
            %   function.
            %
            %   The TextInserter System object draws text in an image. The output
            %   image can then be displayed or saved to a file. It can draw arbitrary
            %   ASCII string(s) at one or more locations in an image.
            %  
            %   txtInserter = vision.TextInserter('string') returns a text inserter
            %   object, txtInserter. Invoking this object's step method, described
            %   below, adds the text in the quotes to an image. The location of where
            %   the text is inserted, font style and other text characteristics are
            %   determined by the properties described below.
            % 
            %   txtInserter = vision.TextInserter(...,'Name', 'Value') configures the
            %   text inserter properties, specified as one or more name-value pair
            %   arguments. Unspecified properties have default values.
            %
            %   Step method syntax:
            %
            %   J = step(txtInserter, I) draws the string specified in Text property
            %   onto image I and returns the result in image J. I can be a 2-D
            %   grayscale image or a truecolor RGB image.
            %
            %   J = step(txtInserter, I, LOC) places the text at the [x y] 
            %   coordinates specified by LOC, when the LocationSource property is 
            %   'Input port'.
            %
            %   J = step(txtInserter, I, VARS) uses the data in VARS for variable
            %   substitution, when the Text property contains ANSI C printf-style
            %   format specifications (%d, %.2f, etc.). VARS is a scalar or a vector
            %   having length equal to the number of format specifiers in each element
            %   of the text string in Text property.
            %
            %   J = step(txtInserter, I, cellIdx) draws the text string selected
            %   by index, cellIdx, when the Text property is a cell array of strings.
            %   For example, when Text property is {'str1','str2'}, and cellIdx = 1, 
            %   'str1' will be drawn in the image. Values of cellIdx, outside of valid
            %   range result in no text drawn in the image.
            %
            %   J = step(txtInserter, I, COLOR) uses a scalar or a 3-element
            %   vector, COLOR, for the text color. This option is available when the 
            %   ColorSource property is 'Input port'.
            %
            %   J = step(txtInserter, I, OPAC) uses OPAC for the text opacity when
            %   the OpacitySource property is set to 'Input port'.
            %
            %   The above operations can be used simultaneously, provided the object
            %   properties are set appropriately. For example,
            %       J = step(txtInserter, I, CELLIDX, VARS, COLOR, LOC, OPAC) 
            %   draws the specified text onto image I using text selected by 
            %   index CELLIDX, text variable substitution data VARS, color value COLOR
            %   at location LOC with opacity OPAC.
            %
            %   TextInserter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create text inserter object with same property values
            %   isLocked - Locked status (logical)
            %
            %   TextInserter properties:
            %
            %   Text            - Text string to draw on image or video stream
            %   ColorSource     - Source of intensity or color of text
            %   Color           - Intensity or color of text
            %   LocationSource  - Source of text location
            %   Location        - Top-left corner of text bounding box
            %   OpacitySource   - Source of opacity of text
            %   Opacity         - Opacity of text
            %   TransposedInput - Specifies if input image data order is row major
            %   Font            - Font face of text
            %   FontSize        - Font size in points
            %   Antialiasing    - Smooth text edges
            %
            %   EXAMPLE 1: Display a text string in an image
            %   --------------------------------------------
            %   textColor    = [255, 255, 255]; % [red, green, blue]
            %   textLocation = [100 315];       % [x y] coordinates
            %   textInserter = vision.TextInserter('Peppers are good for you!', ...);
            %      'Color', textColor, 'FontSize', 24, 'Location', textLocation);
            %
            %   I = imread('peppers.png');
            %   J = step(textInserter, I);
            %   imshow(J);
            %
            %   EXAMPLE 2: Display four numeric values at different locations
            %   -------------------------------------------------------------
            %   textInserter = vision.TextInserter('%d', 'LocationSource', ...
            %      'Input port', 'Color',  [255, 255, 255], 'FontSize', 24);
            %
            %   I = imread('peppers.png');
            %   J = step(textInserter, I, int32([1 2 3 4]), ...
            %            int32([1 1; 500 1; 1 350; 500 350]));
            %   imshow(J);
            %
            %   EXAMPLE 3: Display two strings at different locations
            %   -----------------------------------------------------
            %   textInserter = vision.TextInserter('%s', 'LocationSource', ...
            %      'Input port', 'Color',  [255, 255, 255], 'FontSize', 24);
            %
            %   I = imread('peppers.png');
            %   % create null separated strings
            %   strings = uint8(['left' 0 'right']); 
            %   J = step(textInserter, I, strings, int32([10 1; 450 1]));
            %   imshow(J);
            %
            %   See also insertText, insertShape, insertMarker, insertObjectAnnotation,
            %      vision.AlphaBlender
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Antialiasing Smooth text edges
        %   Set this property to true to smooth the edges of the text.
        %
        %   Default: true
        Antialiasing;

        %Color Intensity or color of text
        %   Specify the intensity or color of the text as a scalar integer value
        %   or a 3-element vector respectively. Alternatively, if the Text
        %   property is a cell array of strings, specify an M-by-1 vector of 
        %   intensity values or M-by-3 matrix of color values that correspond 
        %   to each of M strings. The default value of this property is 
        %   [0 0 0]. The color values must be selected appropriately for the 
        %   given input data range. This property is applicable when the 
        %   ColorSource property is 'Property'. This property is tunable.
        Color;

        %ColorSource Source of intensity or color of text
        %   Select how to specify the intensity or color value of the text as one
        %   of [{'Property'} | 'Input port'].
        ColorSource;

        %Font Font face of text
        %   Specify the font of the text as one of the available truetype fonts
        %   installed on your system. To get a list of available fonts,
        %   use the TAB completion from the command prompt:
        %    >> txtInserter = vision.TextInserter; 
        %    >> txtInserter.Font = '<Press TAB to get a list>
        Font;

        %FontSize Font size in points
        %   Specify the font size as a positive integer value.
        %
        %   Default: 12
        FontSize;

        %Location Top-left corner of text bounding box
        %   Specify the top-left corner of the text bounding box as a 2-element
        %   vector of integers, [x y]. The default value of this property
        %   is [1 1]. This property is applicable when the LocationSource
        %   property is 'Property'. This property is tunable.
        Location;

        %LocationSource Source of text location
        %   Select how to specify the location of the text as one of
        %   [{'Property'} | 'Input port'].
        LocationSource;

        %Opacity Opacity of text
        %   Specify the opacity of the text as numeric scalar between 0 and 1.
        %   The default value of this property is 1. This property is applicable
        %   when the OpacitySource property is 'Property'. This property is
        %   tunable.
        Opacity;

        %OpacitySource Source of opacity of text
        %   Select how to specify the opacity of the text as one of [{'Property'}
        %   | 'Input port'].
        OpacitySource;

        %Text Text string to draw on image or video stream
        %   Specify the text string to be drawn on image or video stream as a
        %   single text string or a cell array of strings. The string(s) can
        %   include ANSI C printf-style format specifications, such as %d, %f,
        %   or %s.
        %
        %   Default: 'Text'
        Text;

        %TransposedInput Specifies if input image data order is row major
        %   Set this property to true to indicate that the input image data order
        %   is row major. 
        %
        %   Default: false
        TransposedInput;

    end
end
