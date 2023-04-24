function toolTipWaitBarHandle = tooltipwaitbar(hObject, progress, message, useContextMenu, usePercentLabel, abortAction)
% TOOLTIPWAITBAR displays a waitbar below a uicontrol.
%
%   toolTipWaitBarHandle = tooltipwaitbar(hObject)
%   Generates a waitbar below a uicontrol (hObject). Returns a 4 element
%   array for the static text boxes which make up the waitbar.  (1) is the
%   progress bar itself, (2) is the background to the waitbar, (3) is the
%   border, and (4) is a UIContextMenu (right-click menu) that can be used
%   which can hide the waitbar, and also gives information on the steps
%   going through (it logs changes of the message using
%   updatetooltipwaitbar). All can be modified using standard set/get
%   notation.  For example, change the colours with:
%       Progress bar: set(toolTipWaitBarHandle(1), 'BackgroundColor',
%       'red')
%       Progress background: set(toolTipWaitBarHandle(2),
%       'BackgroundColor', 'white')
%       Border: set(toolTipWaitBarHandle(3), 'BackgroundColor', 'black')
%
%   ... = tooltipwaitbar(hObject, progress)
%   Pre-defines a progress level of the waitbar, where the progress is any
%   number from 0 to 1, or, from 0 to 100 (whichever it is is dynamically
%   selected.  If left empty, the default is 0.
%
%   ... = tooltipwaitbar(hObject, progress, message)
%   Also supplies a message which appears in the ToolTip for the text box.
%   This can be empty (the default), or a string.
%
%   ... = tooltipwaitbar(hObject, progress, message, useContextMenu)
%   If useContextMenu evaluates to false (the default is true), the context
%   menu is disabled.  If useContextMenu is the handle to a uicontext menu
%   object, then this can be used instead.  CAUTION:  This will error if
%   you accidentally supply the number to a uicontrol that is not a
%   uicontextmenu.  It is recommended this is converted to a logical
%   beforehand if possible.
%
%   ... = tooltipwaitbar(hObject, progress, message, useContextMenu, usePercentLabel)
%   If usePercentLabel evaluates to true (the default is false), the
%   percent label is used.  This is a % label at the right alignment of the
%   progress bar, in white.
%
%   ... = tooltipwaitbar(hObject, progress, message, useContextMenu,
%   usePercentLabel, abortAction)
%   AbortAction specifies what to do when the user clicks on abort.
%   Because of the way it works, the process can only be aborted the next
%   time a callback tries to update the waitbar (e.g. in a loop).  It can
%   be true, 'error', or false.  If true, an abort status flag (retrieved
%   later, see how to update the waitbar) is changed.  If 'error', then the
%   waitbar will deliberately error after the waitbar has been redrawn as
%   normal.  If false (the default), nothing happens.
%
%   NOTE: As transparency is not supported by uicontrols, this looks very
%   bad for low progress stages, because the percent value is larger than
%   the text box, and text wrapping is on by default.  MATLAB appears to
%   have no tools for determining the size of text too, so finding this
%   out, then perhaps moving the percent label to the right of the progress
%   bar at low values does not appear to be possible.
%   
%   To change the label colour:
%       set(toolTipWaitBarHandle(1), 'ForegroundColor', 'yellow')
%
%   To change the label alignment:
%       set(toolTipWaitBarHandle(1), 'HorizontalAlignment', 'left')
%
%   To change the font size (8 is the default in MATLAB):
%       set(toolTipWaitBarHandle(1), 'FontSize', 10)
%
%   tooltipwaitbar(toolTipWaitBarHandle, progress)
%   abortStatus = tooltipwaitbar(toolTipWaitBarHandle, progress);
%   Updates the progress of the waitbar generated using tooltipwaitbar.  If
%   an output argument is supplied, the current abort status is given.
%   This will always be false if the abortAction was not specified when the
%   waitbar was created.
%
%   tooltipwaitbar(toolTipWaitBarHandle, progress, message)
%   Updates the waitbar, as well as the status message in the UIToolTip,
%   and if the context menu is on, updates that too.  If you only want to
%   change the message, progress can also be empty ([]).
%
%   tooltipwaitbar(toolTipWaitBarHandle)
%   Removes the waitbar from the figure.
%
%   More than one tooltip can be used on the same uicontrol without issue,
%   as long the handles are stored properly (the most recent one will be on
%   top of the stack.  No other data is stored. The waitbars stack rather
%   nicely too when a tooltipwaitbar is slaved to another tooltipwaitbar,
%   which makes for some quite interesting visual effects.  The
%   tooltipwaitbar is implemented as a series of overlapping text boxes
%   rather than axes/patch objects because axes are always on the bottom of
%   the UI element stack; if there are any other uicontrols nearby, the
%   text object is obscured.  The context menu to hide the waitbar merely
%   makes it invisible; it may cause problems later otherwise when other
%   functions attempt to clear up.
%
%   Code could apparently be cleaned up by splitting it into sub-functions,
%   but for me it is not immediately obvious where they could be split up.
%   I also considered adding a button to the right of the waitbar to abort
%   it, but it seems like that way it would be too easy to abort it by
%   accident.
%
%   The test GUI I use for new features is also bundled.
%
%
%   An example...
%
% % create a dummy GUI
% hObject = uicontrol('Style', 'pushbutton');
% 
% % create waitbar
% ttwb = tooltipwaitbar(hObject, 0, 'Starting...');
% 
% % calculation
% n = 1;
% x = 3;
% 
% % simple loop
% for m = 1:10 ^ x
%     % calculation
%     n = n + m;
%     pause(0.005)
%     
%     % update waitbar
%     tooltipwaitbar(ttwb, m / 10 ^ x);
% end
% 
% % finish at end
% tooltipwaitbar(ttwb)
% 
% % clear up
% clear('ttwb', 'n', 'm', 'x', 'hObject')


% checks the number of arguments
error(nargchk(1, 6, nargin))

% error checking for if the hObject is the tooltipwaitbar itself.
if numel(hObject) == 3 || numel(hObject) == 4
    % if it might be...
    if any(~ishandle(hObject)) || any(cellfun('isempty', strfind(lower(get(hObject, 'Tag')), 'tooltip')))
        % one of them doesn't have the string "tooltip" (case-insensitive)
        % in the tag, or isn't a handle object
        error('If a 3 or 4 element array is supplied, they must all be valid tooltipwaitbar handles.')
    end
    
else
    % check if for being a valid uicontrol instead
    if ~isscalar(hObject) || ~strcmp(get(hObject, 'Type'), 'uicontrol')
        % handle object must be a single uicontrol - although theoretically you
        % could use a uimenu, it would get a bit weird
        error('Handle graphics object must be a single uicontrol.')
    end
end
        
% check the progress
if nargin >= 2
    % check it
    if ~isempty(progress) && (~isnumeric(progress) || ~isreal(progress) || ~isscalar(progress) || isnan(progress) || progress < 0 || progress > 100)
        % if supplied, the progress must be a scalar from 0 to 1, or 100.
        error('Progress must be a real number from 0 to 1, or 0 to 100.')
    end

    % if the progress is empty, set it to 0
    if isempty(progress) || ~progress
        % set it to very small (can't do it as 0 or we get divide by zero
        % warnings)
        progress = eps;

    elseif progress > 1
        % normalise the progress from 0 to 100, to 0 to 1.
        progress = progress / 100;
    end
else
    % default
    progress = eps;
end

% the the message
if nargin >= 3
    % checks it
    if ~ischar(message) || size(message, 1) > 1
        % the message must be a string
        error('The message must be a string.')
    end

else
    % use a default
    message = '';
end
    
% preliminary checking of the context menu if its a handle object (we've
% already checked if its a positive scalar or not)
if nargin >= 4 && ~isempty(useContextMenu)
    % if it doesn't evaluate as true/false
    if nargin >= 4 && (~isscalar(useContextMenu) || (~isnumeric(useContextMenu) && ~islogical(useContextMenu)) || isnan(useContextMenu))
        % must be an expression which can evaluate as a logical
        error('UseContextMenu must be a valid logical scalar or the handle to a uicontextmenu.')
    end

    % if might be a context menu...
    if useContextMenu && ishandle(useContextMenu) && strcmp(get(useContextMenu, 'Type'), 'uicontrol')
        % check it some more
        if ~strcmp(get(useContextMenu, 'Style'), 'uicontextmenu')
            % error - it must be a valid context menu if it is the handle to a
            % uicontrol
            error('If useContextMenu is a valid uicontrol, it must be the handle to a uicontextmenu.')

        else
            % it is
            useContextMenuAsHandle = true;
        end

    else
        % its not
        useContextMenuAsHandle = false;
    end
    
else
    % define it as true by default
    useContextMenu = true;
    useContextMenuAsHandle = false;
end

%  checks the usePercentLabel flag
if nargin >= 5 && (~isscalar(usePercentLabel) || (~isnumeric(usePercentLabel) && ~islogical(usePercentLabel)) || isnan(usePercentLabel))
    % must be an expression which can evaluate as a logical
    error('UsePercentLabel must be a valid logical scalar.')
    
elseif nargin < 5
    % default
    usePercentLabel = false;
end

% and whether we are applying abort
if nargin >= 6 && ~isequal(abortAction, true) && ~isequal(abortAction, false) && ~isequal(abortAction, 'error')
    % must be valid
    error('The abort action must be true, false, or ''error''.')
    
elseif nargin < 6
    % default
    abortAction = false;
end

% shortcutting for updating and deleting the tooltip
if numel(hObject) == 3 || numel(hObject) == 4
    % if no additional arguments, then delete it
    if nargin <= 1
        % run the delete sub-function
        deletetooltipwaitbar(hObject)

    elseif nargin <= 2
        % depends in abort is on...
        if any(getappdata(hObject(1), 'abortAction'))
            % run the update routine, returning the info
            toolTipWaitBarHandle = updatetooltipwaitbar(hObject, progress);

        else
            % don't return it
            updatetooltipwaitbar(hObject, progress)
        end

    elseif nargin <= 3
        % same
        if any(getappdata(hObject(1), 'abortAction'))
            % run the update routine, return the info
            toolTipWaitBarHandle = updatetooltipwaitbar(hObject, progress, message);
    
        else
            % don't return it
            updatetooltipwaitbar(hObject, progress, message)
        end
        
    else
        % error
        error('Too many arguments to update the tooltip waitbar.')
    end
    
    % then return to the calling function
    return
end

% gets the parent figure/uipanel
parent = get(hObject, 'Parent');

% gets the old units of the uicontrol
oldUnits = get(hObject, 'Units');

% changes them to pixels so we can get them in those units
set(hObject, 'Units', 'pixels')

% get the size and position of the supplied uicontrol in pixels
position = get(hObject, 'Position');

% changes them back (would it be any quicker to do a quick strcmp before we
% change them back?)
set(hObject, 'Units', oldUnits)

% calculates the position of the tooltip starting in the bottom corner of
% the uicontrol - making it 75% of the height of the uicontrol so its clear
% that it is a subordinate GUI element
toolTipPosition = [position(1:3), 0.75 * position(4)];

% shifts it down 1 pixel to allow for the border of the tooltip waitbar
toolTipPosition(2) = toolTipPosition(2) - 1;

% need to adjust it a little if it is for a button
if strcmp(get(hObject, 'Style'), 'pushbutton')
    % shifts it forward a pixel and shrinks it (not sure exactly why this
    % is necessary, but it is)
    toolTipPosition(1) = toolTipPosition(1) + 1;
    toolTipPosition(3) = toolTipPosition(3) - 2;
end

% pre-allocates the handles - the uicontrols are created in reverse order
% so that everything is stacked correctly, and that way we don't have to
% reorder everything later
toolTipWaitBarHandle = zeros(3, 1);

% generates a text box one pixel wider to act as a border
toolTipWaitBarHandle(3) = uicontrol(    'Style', 'text',...
                                        'BackgroundColor', 'black',...
                                        'Parent', parent,...
                                        'Units', 'pixels',...
                                        'Position', [toolTipPosition(1:2) - 1, toolTipPosition(3:4) + 2],...
                                        'Visible', 'off',...
                                        'ToolTipString', message,...
                                        'Tag', 'toolTipWaitBarBorder');

% generates a static text uicontrol which will be the background to the
% progress bar, uses the default background colour
toolTipWaitBarHandle(2) = uicontrol(    'Style', 'text',...
                                        'Parent', parent,...
                                        'Units', 'pixels',...
                                        'Position', toolTipPosition,...
                                        'Visible', 'off',...
                                        'ToolTipString', message,...
                                        'Tag', 'toolTipWaitBarBackground');

% creates another text box to act as the progress bar
toolTipWaitBarHandle(1) = uicontrol(    'Style', 'text',...
                                        'BackgroundColor', 'blue',...
                                        'Parent', parent,...
                                        'Units', 'pixels',...
                                        'Position', [   toolTipPosition(1:2),....
                                                        toolTipPosition(3) * progress,...
                                                        toolTipPosition(4)],...
                                        'Visible', 'off',...
                                        'ToolTipString', message,...
                                        'Tag', 'toolTipWaitBarProgress');
                                    
% store the abort status
setappdata(toolTipWaitBarHandle(1), 'abortAction', abortAction)
setappdata(toolTipWaitBarHandle(1), 'abortStatus', false)

% if the percent label is going to be used, apply it
if nargin >= 5 && usePercentLabel
    % apply it - padding the end of the sprintf doesn't work ffs
    set(toolTipWaitBarHandle(1),    'HorizontalAlignment', 'right',...
                                    'ForegroundColor', 'white',...
                                    'String', sprintf('%.0f%%', progress * 100))
end

% if the context menu is to be used
if useContextMenu
    % if a valid uicontextmenu was supplied, use that
    if useContextMenuAsHandle
        % use that
        set(toolTipWaitBarHandle, 'UIContextMenu', useContextMenu)
        
        % also store it in toolTipWaitBarHandle for convenience
        toolTipWaitBarHandle(4) = useContextMenu;

    else
        % loops round until it finds a figure or if it was the root (to stop
        % loops) - we can't make the parents of UIContextMenus uipanels
        while ~strcmp(get(parent, 'Type'), 'figure') && parent
            % find the parent again
            parent = get(parent, 'Parent');
        end

        % only go futher if the parent figure was located, and not the root
        if parent
            % store the menu in the toolTipWaitBarHandle so it gets deleted
            % properly
            toolTipWaitBarHandle(4) = uicontextmenu('Parent', parent,...
                                                    'Tag', 'toolTipWaitBarContextMenu');

            % providing there was a message,...
            if ~isempty(message)
                % now generate UI menus with the current task on it (don't
                % need to store these, since they're in the children of the
                % uicontextmenu)
                uimenu( 'Parent', toolTipWaitBarHandle(4),...
                        'Label', message,...
                        'Enable', 'off',...
                        'Tag', 'toolTipWaitBarMenuItem')

                % define whether we want the separator or not (looks ugly
                % if there is only one menu item and a separator
                separator = 'on';

            else
                % turn it off
                separator = 'off';
            end
            
            % if the abort action is on...
            if abortAction
                % add an item for this
                uimenu( 'Parent', toolTipWaitBarHandle(4),...
                        'Label', 'Abort',...
                        'Callback', {@abortCallback, toolTipWaitBarHandle},...
                        'Separator', separator,...
                        'Tag', 'toolTipWaitBarAbortMenu')

                % then turn the separator off for the next part, so we
                % don't get two separators
                separator = 'off';
            end
                
            % generate the callback at the bottom to hide the waitbar
            uimenu( 'Parent', toolTipWaitBarHandle(4),...
                    'Label', 'Hide Progress Bar',...
                    'Callback', {@hideToolTipWaitBar, toolTipWaitBarHandle},...
                    'Separator', separator,...
                    'Tag', 'toolTipWaitBarHideMenu')

            % add the context menu to the tooltips
            set(toolTipWaitBarHandle(1:3), 'UIContextMenu', toolTipWaitBarHandle(4))
        end
    end
end

% animation parts - do in approximately 3 pixel steps - the MATLAB internal
% rounding will take care of things
animationSteps = round(toolTipPosition(4) / 3);
animationTime = 0.04;
animationStepTime = animationTime / animationSteps;

% defines the height (a little redundant, but good for pedagogic purposes)
height = toolTipPosition(4);

% loops to animate it
for m = 1:animationSteps
    % short pause if its not the first one
    if m ~= 1
        % short pause
        pause(animationStepTime)
    end
    
    % generates a new position
    newToolTipPosition = [  toolTipPosition(1),...
                            toolTipPosition(2) - (height * (m / animationSteps)),...
                            toolTipPosition(3),...
                            height * (m / animationSteps)];
                        
    % moves the border first
    set(toolTipWaitBarHandle(3), 'Position', [  newToolTipPosition(1:2) - 1,...
                                                newToolTipPosition(3:4) + 2])

    % change the position of the background
    set(toolTipWaitBarHandle(2), 'Position', newToolTipPosition)
    
    % the progress bar too
    set(toolTipWaitBarHandle(1), 'Position', [  newToolTipPosition(1:2),...
                                                newToolTipPosition(3) * progress,...
                                                newToolTipPosition(4)])
    
    % if its the first one, make them all visible too
    if m == 1
        % make it visible
        set(toolTipWaitBarHandle, 'Visible', 'on')
    end
end



% callback for hiding the waitbar if requested
function hideToolTipWaitBar(hObject, eventdata, toolTipWaitBarHandle)

% hides it (including itself)
set(toolTipWaitBarHandle, 'Visible', 'off')



% callback for aborting the action
function abortCallback(hObject, eventdata, toolTipWaitBarHandle)

% gets the tick status (this is not changed automatically - you need to do
% this yourself), and converts it to what it should be now
checkStatus = get(hObject, 'Checked');

% depends
if strcmp(checkStatus, 'on')
    % turn it off
    checkStatus = 'off';
    
    % revert
    message = 'Abort';
    
    % its not checked
    checkLogical = false;
    
else
    % turn it on
    checkStatus = 'on';
    
    % change
    message = 'Aborting...';
    
    % it is
    checkLogical = true;
end

% changes the tick status to the opposite of what it was, and change the
% message
set(hObject,    'Checked', checkStatus,...
                'Label', message)

% set the appdata to show that it errored
setappdata(toolTipWaitBarHandle(1), 'abortStatus', checkLogical)


function varargout = updatetooltipwaitbar(toolTipWaitBarHandle, progress, message)
% UPDATETOOLTIPWAITBAR changes the tooltip waitbar progress and message.

% gets the old units
oldUnits = get(toolTipWaitBarHandle(1:3), 'Units');

% changes them to pixels (I shouldn't HAVE to do this, but you never know)
set(toolTipWaitBarHandle(1:3), 'Units', 'pixels')

% gets the position of the tooltip (the background part)
toolTipPosition = get(toolTipWaitBarHandle(2), 'Position');

% and the progress bar
toolTipProgressPosition = get(toolTipWaitBarHandle(1), 'Position');

% finds the progress
currentProgress = toolTipProgressPosition(3) / toolTipPosition(3);

% defines the change
progressChange = progress - currentProgress;

% only do something if it has changed significantly (to reduce CPU load in
% intensive calculations)
if abs(progressChange) >= 0.005
    % change the label if necessary - uses the existence of a string in the
    % progress bar text box as proof that it needs to be changed.
    if ~isempty(get(toolTipWaitBarHandle(1), 'String'))
        % change it
        set(toolTipWaitBarHandle(1), 'String', sprintf('%.0f%%', progress * 100))
    end
    
    % animates the change
    animationSteps = abs(round(progressChange * 20));
    animationTime = 0.04;
    animationStepTime = animationTime / animationSteps;

    % for each step
    for m = 1:abs(animationSteps)
        % short pause if its not the first one
        if m ~= 1
            % short pause
            pause(animationStepTime)
        end

        % applies the new position
        set(toolTipWaitBarHandle(1), 'Position', [  toolTipPosition(1:2),...
                                                    toolTipProgressPosition(3) + (progressChange * toolTipPosition(3) * (m / animationSteps)),...
                                                    toolTipPosition(4)]);
    end
end

% restores the units
set(toolTipWaitBarHandle(1:3), {'Units'}, oldUnits)

% find out if their is an abort action
abortAction = getappdata(toolTipWaitBarHandle(1), 'abortAction');

% convert the message first if its there
if nargin >= 3
    % if there is a message, update the text object
    if ~isempty(message)
        % update the tooltip
        set(toolTipWaitBarHandle(1:3), 'ToolTipString', message)
        
        % gets the UI context menu
        contextMenu = get(toolTipWaitBarHandle(1), 'UIContextMenu');

        % if there is a context menu, start manipulating it
        if ~isempty(contextMenu)
            % generate a new item
            uimenu( 'Parent', contextMenu,...
                    'Label', message,...
                    'Enable', 'off')

            % get the children - they are stacked in REVERSE order
            menuItems = get(contextMenu, 'Children');

            % slightly different if abort is on
            if abortAction
                % the new one is on the top, and we want "Hide" to be the first one (so
                % last in the menu), then abort next
                menuItems(1:3) = menuItems([2:3, 1]);

                % save it back
                set(contextMenu, 'Children', menuItems)

                % then check the most recent item, only if it exists
                if numel(menuItems) > 3
                    % check it
                    set(menuItems(4), 'Checked', 'on')
                end

                % if there are now 3, then we need to enable the separator
                % on the last one (it appears ABOVE the menu item)
                if numel(menuItems) == 3
                    % enable it
                    set(menuItems(2), 'Separator', 'on')
                end

            else
                % the new one is on the top, and we want "Hide" to be the first one (so
                % last in the menu)
                menuItems(1:2) = menuItems(2:-1:1);

                % save it back
                set(contextMenu, 'Children', menuItems)

                % then check the most recent item, only if it exists
                if numel(menuItems) > 2
                    % check it
                    set(menuItems(3), 'Checked', 'on')
                end

                % if there are now 2, then we need to enable the separator
                if numel(menuItems) == 2
                    % enable it
                    set(menuItems(1), 'Separator', 'on')
                end
            end
        end
    end
end

% retrives the abort status
abortStatus = getappdata(toolTipWaitBarHandle(1), 'abortStatus');

% now the actual abort section
if isequal(abortAction, 'error') && abortStatus
    % then deliberately error
    error('Task was aborted.')
    
elseif any(abortAction)
    % return it if the abortAction is enabled
    varargout{1} = abortStatus;
end


function deletetooltipwaitbar(toolTipWaitBarHandle)
% DELETETOOLTIPWAITBAR clears the tooltip waitbar (animated).
%   If it errors at any point, it reverts to using DELETE to tidy up for
%   robustness.

% try-catched to always cleanup
try
    % sets the units back to pixels (don't need to be tidy this time)
    set(toolTipWaitBarHandle(1:3), 'Units', 'pixels')

    % gets the position of the background part
    toolTipPosition = get(toolTipWaitBarHandle(2), 'Position');

    % gets the position of the progress bar
    toolTipProgressPosition = get(toolTipWaitBarHandle(1), 'Position');

    % defines the progress
    progress = toolTipProgressPosition(3) / toolTipPosition(3);

    % defines the height
    height = toolTipPosition(4);

    % defines some default animation steps
    animationSteps = round(toolTipPosition(4) / 3);
    animationTime = 0.04;
    animationStepTime = animationTime / animationSteps;

    % loops to animate it (rolls it up)
    for m = 1:animationSteps - 1
        % short pause
        pause(animationStepTime)

        % defines the new position
        newToolTipPosition = [  toolTipPosition(1),...
                                toolTipPosition(2) + (height * (m / animationSteps)),...
                                toolTipPosition(3),...
                                toolTipPosition(4) - toolTipPosition(4) * (m / animationSteps)];

        % change the position
        set(toolTipWaitBarHandle(1), 'Position', [  newToolTipPosition(1:2),...
                                                    newToolTipPosition(3) * progress,...
                                                    newToolTipPosition(4)])
        set(toolTipWaitBarHandle(2), 'Position', newToolTipPosition)
        set(toolTipWaitBarHandle(3), 'Position', [  newToolTipPosition(1:2) - 1,...
                                                    newToolTipPosition(3:4) + 2])
    end

catch
    % give a warning
    warning('deleteToolTipWaitBar:cleanUpError', 'Tooltip may not have been cleaned up properly.')
end

% deletes them all (that aren't 0's) - done using a double not, because
% LOGICAL always gives a warning when values aren't 0 or 1
delete(toolTipWaitBarHandle(~~toolTipWaitBarHandle))