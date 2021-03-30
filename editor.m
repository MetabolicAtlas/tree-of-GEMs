function editor
%i edits model i
if isfile('dataset.mat')==0
    json_packer
end
%% Sidebar
%text feild: 
%CONNECTION:sub(PMID, connection type, citation, citation link, notes) 
%ARTICLE INFORMATION:sub(PMID, DOI, name(common), name(scientific), taxonomy id) 
%MISC:sub(intitials, time, checking status, end session button)
clf;
bg = uibuttongroup('Visible','off',...
                  'Position',[0 0 .25 1],...
                  'SelectionChangedFcn',@bselection);
              
% Create three radio buttons in the button group.
r2 = uicontrol(bg,'Style','radiobutton',...
  'String',['Article information'],...
  'Position',[10 250 120 30],...
  'HandleVisibility','off');

r1 = uicontrol(bg,'Style',...
                  'radiobutton',...
                  'String','Connection',...
                  'Position',[10 200 120 30],...
                  'HandleVisibility','off');   

r3 = uicontrol(bg,'Style','radiobutton',...
                  'String','Misc',...
                  'Position',[10 150 120 30],...
                  'HandleVisibility','off');

textChildMLnr = uicontrol('Style','text',...
                        'String','Child MATLAB nr.:',...
                        'Position',[10 370 120 30],...
                        'HandleVisibility','off');
                    
currentChildMLnr = uicontrol('Style','edit',...
                  'Position',[10 350 120 30],...
                  'HandleVisibility','off',...
                  'KeyPressFcn',@getchildpmid);
              
textChildPMID = uicontrol('Style','text',...
                        'String','Child PMID.:',...
                        'Position',[10 310 120 30],...
                        'HandleVisibility','off');
                    
currentChildPMID = uicontrol('Style','edit',...
                  'Position',[10 290 120 30],...
                  'HandleVisibility','off',...
                  'KeyPressFcn',@getchildMLnr);
% currentChild = 
%% Connection              
p = uipanel('Position',[.25 0 0.75 1],...
            'Visible','on');
text_PMID = uicontrol(p,'Style','text',...
                        'String','Parent PMID',...
                        'Position',[10 370 120 30],...
                        'HandleVisibility','off');
ef1 = uicontrol(p,'Style','edit',...
                  'Position',[10 350 120 30],...
                  'HandleVisibility','off');
              
text_Connection_type = uicontrol(p,'Style','text',...
                        'String','Connection type',...
                        'Position',[10 310 120 30],...
                        'HandleVisibility','off');
ef2 = uicontrol(p,'Style','listbox',...
                  'String',{'Direct','Partial'},...
                  'Position',[10 290 120 30],...
                  'HandleVisibility','off');              

text_Citation = uicontrol(p,'Style','text',...
                        'String','Citation',...
                        'Position',[10 250 120 30],...
                        'HandleVisibility','off');
ef3 = uicontrol(p,'Style','edit',...
                  'Position',[10 150 400 110],...
                  'HandleVisibility','off',...
                  'FontSize',8,...
                  'Max',2);
              
text_CitationLink = uicontrol(p,'Style','text',...
                        'String','Citation link',...
                        'Position',[10 110 120 30],...
                        'HandleVisibility','off');
ef4 = uicontrol(p,'Style','edit',...
                  'Position',[10 100 400 20],...
                  'HandleVisibility','off');
              
text_Notes = uicontrol(p,'Style','text',...
                        'String','Notes',...
                        'Position',[10 60 120 30],...
                        'HandleVisibility','off');
ef5 = uicontrol(p,'Style','edit',...
                  'Position',[10 30 400 40],...
                  'HandleVisibility','off');
              
              
button_Connection = uicontrol(p,'Style','pushbutton',...
                'String','Add connection',...
                'Position',[200 350 120 30],...
                'HandleVisibility','off',...
                'Callback',@commit);
%% Misc            
p_misc = uipanel('Position',[.25 0 0.75 1],...
            'Visible','off');

        text_Person = uicontrol(p_misc,'Style','text',...
                        'String','Person',...
                        'Position',[10 370 120 30],...
                        'HandleVisibility','off');
initials={'GS' 'EB' 'LW' 'KL' 'JY' 'YL'};
for i=6:-1:1
misc_initals(i) = uicontrol(p_misc,'Style','checkbox',...
                  'Position',[30 350-20*(i-1) 120 20],...
                  'String',initials{i},...
                  'HandleVisibility','off');
end



text_Time = uicontrol(p_misc,'Style','text',...
                        'String','Time taken (/min)',...
                        'Position',[10 210 120 30],...
                        'HandleVisibility','off');
timeText = uicontrol(p_misc,'Style','edit',...
                  'Position',[10 190 120 30],...
                  'HandleVisibility','off',...
                  'FontSize',8);

text_Status = uicontrol(p_misc,'Style','text',...
                        'String','Status',...
                        'Position',[10 150 120 30],...
                        'HandleVisibility','off');
listStatus = uicontrol(p_misc,'Style','listbox',...
                  'String',{'Finished' 'Unfinshed' 'Not checked'},...
                  'Position',[10 115 120 45],...
                  'HandleVisibility','off');
              
button_end = uicontrol(p_misc,'Style','pushbutton',...
                'String','End session',...
                'Position',[200 250 120 30],...
                'HandleVisibility','off',...
                'Callback',@endsession);

button_add = uicontrol(p_misc,'Style','pushbutton',...
                'String','Add information',...
                'Position',[200 350 120 30],...
                'HandleVisibility','off',...
                'Callback',@addmisc);            
%% Make the uibuttongroup visible after creating child objects. 
bg.Visible = 'on';
%% Callbacks
    function bselection(source,event)
        p.Visible = 'off';
        p_misc.Visible = 'off';
%         p_ai.Visible = 'off';
        if strcmp(bg.SelectedObject.String,'Connection')==1
            p.Visible = 'on';
        elseif strcmp(bg.SelectedObject.String,'Misc')==1
            %load information on person/time/status
            p_misc.Visible = 'on';
        elseif strcmp(bg.SelectedObject.String,'Article information')==1
%             p_ai.Visible = 'on';
        end
    end

%     function bselection_r1(source,event)
%         if strcmp(bg.SelectedObject.String,'Connection')==1
%             bg_r1.Visible = 'on';
%         else
%             bg_r1.Visible = 'off';
%         end
% 
%     end

function commit(source,event)
    %Code that adds info to dataset.mat
    ef1.String='';  %String is PMID
    ef2.String{ef2.Value};      %Value=1 is direct, Value=2 is partial
    ef3.String='';  %String is Citation
    ef4.String='';  %String is Citation Link
    ef5.String='';  %String is Notes
end

    function endsession(source,event)
        if isfile('dataset.mat')==1
            json_packer
        end
        close
    end

    function addmisc(source,event)
        for i=length(misc_initals):-1:1
        %dataset.misc.author.(initials(i))=misc_initals(i).Value
        end
        str2double(timeText.String)
        listStatus.String{listStatus.Value}
    end

    function getchildpmid(source,event)
        if strcmp(event.Key,'return')
            currentChildPMID.String='placeholder';
        end
    end

    function getchildMLnr(source,event)
        if strcmp(event.Key,'return')
            currentChildMLnr.String='placeholder';
        end
    end
end




