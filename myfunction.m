function output_txt = myfunction(obj,event_obj)
% Display data cursor position in a data tip
% obj          Currently not used
% event_obj    Handle to event object
% output_txt   Data tip text, returned as a character vector or a cell array of character vectors

if strcmpi(get(event_obj.Target, 'type'), 'image')
    pos = event_obj.Position;
    cdata = event_obj.Target.CData;
    isboundary = mean([cdata(pos(2),pos(1)),cdata(pos(2)+1,pos(1)),cdata(pos(2)-1,pos(1)),...
        cdata(pos(2),pos(1)+1),cdata(pos(2),pos(1)-1)]);
    
    if cdata(pos(2),pos(1))== 0 || isboundary >= 1
        boundary= "No";
    else
        boundary= "Yes";
    end
    
    
    %********* Define the content of the data tip here *********%
    % Display the x and y values:
    if islogical(cdata)
        output_txt = {['[Y,X]',formatValue([pos(2),pos(1)],'[Y,X]',event_obj)],...
            ['Index',formatValue(cdata(pos(2),pos(1)),'Index',event_obj)],...
            ['Is boundary ?',formatValue(boundary,'Is boundary ?',event_obj)]};
    else
        % Display the x and y values:
        output_txt = ['[Y,X]',formatValue([pos(2),pos(1)],'[Y,X]',event_obj)];
    end
    %***********************************************************%
    
    
    % If there is a z value, display it:
    if length(pos) > 2
        output_txt = ['[X,Y,Z]',formatValue([pos(2),pos(1),pos(3)],'[X,Y,Z]',event_obj)];
    end
    
    %***********************************************************%
else
    pos = event_obj.Position;
    output_txt = ['[X,Y]',formatValue([pos(2),pos(1)],'[X,Y]',event_obj)];
end
    function formattedValue = formatValue(value,text,event_obj)
        % If you do not want TeX formatting in the data tip, uncomment the line below.
        % event_obj.Interpreter = 'none';
        if strcmpi(event_obj.Interpreter,'tex')
            if strcmpi(text,'Is boundary ?') %If text is "is boundary" - adapt color
                removeValueFormat = '\color[rgb]{.25 .25 .25}\rm';
                if value == "Yes"
                    valueFormat = ' \color[rgb]{.0 0.74 0.37}\bf';
                else
                    valueFormat = ' \color[rgb]{1 .13 .13}\bf';
                end
            else
                valueFormat = ' \color[rgb]{0 0.6 1}\bf';
                removeValueFormat = '\color[rgb]{.25 .25 .25}\rm';
            end
            
        else % Interpreter is none
            valueFormat = ': ';
            removeValueFormat = '';
        end
        
        %Format Value according to the type of array
        if isnumeric(value)
            if length(value) < 3
                formattedValue = [valueFormat char("["+value(1)+" "+value(2)+"]") removeValueFormat];
            else
                formattedValue = [valueFormat char("["+value(1)+" "+value(2)+" "+value(3)+"]") removeValueFormat];
            end
        else
            formattedValue = [valueFormat num2str(value) removeValueFormat];
        end
    end
end