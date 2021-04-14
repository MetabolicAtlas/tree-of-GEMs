function editorGUI(dataset)
%i edits model i
fig=figure(1);
fig.CloseRequestFcn = @closefun;

%text field:
%CONNECTION:sub(PMID, connection type, citation, citation link, notes)
%ARTICLE INFORMATION:sub(PMID, DOI, name(common), name(scientific), taxonomy id)
%MISC:sub(intitials, time, checking status)
%% Sidebar
clf;
bg = uibuttongroup(fig,'Visible','off',...
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
    'HandleVisibility','off',...
    'Value',1);

r3 = uicontrol(bg,'Style','radiobutton',...
    'String','Misc',...
    'Position',[10 150 120 30],...
    'HandleVisibility','off');

textChildMLnr = uicontrol(fig,'Style','text',...
    'String','Child MATLAB nr.:',...
    'Position',[10 370 120 30],...
    'HandleVisibility','off');

currentChildMLnr = uicontrol(fig,'Style','edit',...
    'Position',[10 350 120 30],...
    'HandleVisibility','off',...
    'KeyPressFcn',@getchildpmid);

textChildPMID = uicontrol(fig,'Style','text',...
    'String','Child PMID.:',...
    'Position',[10 310 120 30],...
    'HandleVisibility','off');

currentChildPMID = uicontrol(fig,'Style','edit',...
    'Position',[10 290 120 30],...
    'HandleVisibility','off',...
    'KeyPressFcn',@getchildMLnr);
%% Article Info
articleInfo = uipanel(fig,...
    'Position',[.25 0 0.75 1],...
    'Visible','off');

textAItitle = uicontrol(articleInfo,'Style','text',...
    'Position',[250 250 160 100],...
    'HandleVisibility','off');

text_PMID = uicontrol(articleInfo,'Style','text',...
    'String','Article PMID',...
    'Position',[10 370 120 30],...
    'HandleVisibility','off');
AIpmid = uicontrol(articleInfo,'Style','edit',...
    'Position',[10 350 120 30],...
    'HandleVisibility','off');

text_DOI = uicontrol(articleInfo,'Style','text',...
    'String','DOI',...
    'Position',[10 310 120 30],...
    'HandleVisibility','off');
AIDOI = uicontrol(articleInfo,'Style','edit',...
    'Position',[10 290 200 30],...
    'HandleVisibility','off');

text_taxCommon = uicontrol(articleInfo,'Style','text',...
    'String','Common Name',...
    'Position',[10 250 120 30],...
    'HandleVisibility','off');
AItaxCommon = uicontrol(articleInfo,'Style','edit',...
    'Position',[10 150 400 110],...
    'HandleVisibility','off');

text_taxSci = uicontrol(articleInfo,'Style','text',...
    'String','Scientific Name',...
    'Position',[10 110 120 30],...
    'HandleVisibility','off');

AItaxSci = uicontrol(articleInfo,'Style','edit',...
    'Position',[10 100 400 20],...
    'HandleVisibility','off');

text_taxID = uicontrol(articleInfo,'Style','text',...
    'String','Taxon ID (Pubmed)',...
    'Position',[10 60 120 30],...
    'HandleVisibility','off');

AItaxID = uicontrol(articleInfo,'Style','edit',...
    'Position',[10 30 400 40],...
    'HandleVisibility','off');


button_Connection = uicontrol(articleInfo,'Style','pushbutton',...
    'String','Add Article Information',...
    'Position',[200 350 120 30],...
    'HandleVisibility','off',...
    'Callback',@addarticleInformation);
%% Connection
p = uipanel(fig,...
    'Position',[.25 0 0.75 1],...
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
p_misc = uipanel(fig,...
    'Position',[.25 0 0.75 1],...
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
timeText = uicontrol(p_misc,...
    'Style','edit',...
    'Position',[10 190 120 30],...
    'HandleVisibility','off',...
    'FontSize',8);
totalTime = uicontrol(p_misc,...
    'Style','text',...
    'String','',...
    'Position',[130 183 85 30],...
    'HandleVisibility','off');

text_Status = uicontrol(p_misc,'Style','text',...
    'String','Status',...
    'Position',[10 150 120 30],...
    'HandleVisibility','off');
listStatus = uicontrol(p_misc,'Style','listbox',...
    'String',{'Finished' 'Unfinshed' 'Not checked'},...
    'Position',[10 115 120 45],...
    'HandleVisibility','off');

button_add = uicontrol(p_misc,'Style','pushbutton',...
    'String','Add information',...
    'Position',[200 350 120 30],...
    'HandleVisibility','off',...
    'Callback',@addmisc);
%% Make the uibuttongroup visible after creating child objects.
bg.Visible = 'on';
%% Callbacks
    function bselection(source,event) %Switch display based on sidebar
        p.Visible = 'off';
        p_misc.Visible = 'off';
        articleInfo.Visible = 'off';
        if strcmp(bg.SelectedObject.String,'Connection')==1
            p.Visible = 'on';
        elseif strcmp(bg.SelectedObject.String,'Misc')==1
            MLnr=str2double(currentChildMLnr.String);
            if 0 == isfield(dataset(MLnr),'misc')
                dataset(MLnr).misc = [];
            end
            for i=1:length(misc_initals)
                temp=initials{i};
                if 0 == isfield(dataset(MLnr).misc,temp)
                    dataset(MLnr).misc.(temp) = 0;
                end
                misc_initals(i).Value=dataset(MLnr).misc.(temp);
            end
            if 0 == isfield(dataset(MLnr).misc,'time')
                dataset(MLnr).misc.time = [];
            end
            if 1==isempty(dataset(MLnr).misc.time)
                dataset(MLnr).misc.time = 0;
            end
            totalTime.String=...
                ['Total time:' char(string(dataset(MLnr).misc.time)) ' min'];
            if 0 == isfield(dataset(MLnr).misc,'status')
                dataset(MLnr).misc.status = 'Not checked';
            end
            val=sum([1 2 3].*strcmp(listStatus.String,dataset(MLnr).misc.status)');
            listStatus.Value=val;
            p_misc.Visible = 'on';
        elseif strcmp(bg.SelectedObject.String,'Article information')==1
            AIpmid.String='';
            AIDOI.String='';
            AItaxCommon.String='';
            AItaxSci.String='';
            AItaxID.String='';
            MLnr=str2double(currentChildMLnr.String);
            textAItitle.String = dataset(MLnr).title;
            if 0 == isfield(dataset,'articleInformation')
                dataset(MLnr).articleInformation = [];
            end
            if isfield(dataset(MLnr).articleInformation,'PMID')
                AIpmid.String = dataset(MLnr).articleInformation.PMID;
            end
            if isfield(dataset(MLnr).articleInformation,'DOI')
                AIDOI.String = dataset(MLnr).articleInformation.DOI;
            end
            if isfield(dataset(MLnr).articleInformation,'taxName')
                AItaxCommon.String = dataset(MLnr).articleInformation.taxName;
            end
            if isfield(dataset(MLnr).articleInformation,'taxSciName')
                AItaxSci.String = dataset(MLnr).articleInformation.taxSciName;
            end
            if isfield(dataset(MLnr).articleInformation,'taxID')
                AItaxID.String = dataset(MLnr).articleInformation.taxID;
            end
            articleInfo.Visible = 'on';
        end
    end

    function commit(source,event)
        %Code that adds info to dataset.mat
        MLnr = str2double(currentChildMLnr.String);
        if 0 == isfield(dataset,'connection')
            dataset(MLnr).connection = [];
        end
        newConnPos = 1 + length(dataset(MLnr).connection);
        dataset(MLnr).connection(newConnPos).PMID = ef1.String;  %String is PMID
        dataset(MLnr).connection(newConnPos).connType = ef2.String{ef2.Value}; %Value=1 is direct, Value=2 is partial
        dataset(MLnr).connection(newConnPos).cit = ef3.String;  %String is Citation
        dataset(MLnr).connection(newConnPos).citLink = ef4.String;  %String is Citation Link
        dataset(MLnr).connection(newConnPos).notes = ef5.String;  %String is Notes
        %clear connection
        ef1.String='';
        ef3.String='';
        ef4.String='';
        ef5.String='';
    end

    function closefun(source,event)
        save('dataset.mat','dataset')
        json_packer
        delete(fig)
    end

    function addarticleInformation(source,event)
        %Code that adds info to dataset.mat
        MLnr = str2double(currentChildMLnr.String);
        if 0 == isfield(dataset,'articleInformation')
            dataset(MLnr).articleInformation = [];
        end
        dataset(MLnr).articleInformation.PMID = AIpmid.String;
        dataset(MLnr).articleInformation.DOI = AIDOI.String;
        dataset(MLnr).articleInformation.taxName = AItaxCommon.String;
        dataset(MLnr).articleInformation.taxSciName = AItaxSci.String;
        dataset(MLnr).articleInformation.taxID = AItaxID.String;
    end

    function addmisc(source,event)
        MLnr=str2double(currentChildMLnr.String);
        for i=1:length(misc_initals)
            temp=initials{i};
            dataset(MLnr).misc.(temp) = misc_initals(i).Value;
        end
        if 1==isempty(dataset(MLnr).misc.time)
            dataset(MLnr).misc.time = 0;
        end
        if 1==isempty(timeText.String)
            timeText.String = '0';
        end
        dataset(MLnr).misc.time = ...
            dataset(MLnr).misc.time+str2double(timeText.String);
        timeText.String = '';
        dataset(MLnr).misc.status=listStatus.String{listStatus.Value};
        totalTime.String = ...
            ['Total time:' char(string(dataset(MLnr).misc.time)) ' min'];
    end

    function getchildpmid(source,event)
        if strcmp(event.Key,'return')
            %clear connection
            ef1.String='';
            ef3.String='';
            ef4.String='';
            ef5.String='';
            AIpmid.String='';
            AIDOI.String='';
            AItaxCommon.String='';
            AItaxSci.String='';
            AItaxID.String='';
            
            MLnr=str2double(currentChildMLnr.String);
            currentChildPMID.String=dataset(MLnr).articleInformation.PMID;
            if strcmp(bg.SelectedObject.String,'Article information')==1
                MLnr=str2double(currentChildMLnr.String);
                textAItitle.String = dataset(MLnr).title;
                if 0 == isfield(dataset,'articleInformation')
                    dataset(MLnr).articleInformation = [];
                end
                if isfield(dataset(MLnr).articleInformation,'PMID')
                    AIpmid.String = dataset(MLnr).articleInformation.PMID;
                end
                if isfield(dataset(MLnr).articleInformation,'DOI')
                    AIDOI.String = dataset(MLnr).articleInformation.DOI;
                end
                if isfield(dataset(MLnr).articleInformation,'taxName')
                    AItaxCommon.String = dataset(MLnr).articleInformation.taxName;
                end
                if isfield(dataset(MLnr).articleInformation,'taxSciName')
                    AItaxSci.String = dataset(MLnr).articleInformation.taxSciName;
                end
                if isfield(dataset(MLnr).articleInformation,'taxID')
                    AItaxID.String = dataset(MLnr).articleInformation.taxID;
                end
                articleInfo.Visible = 'on';
            end
        end
    end

    function getchildMLnr(source,event)
        if strcmp(event.Key,'return')
            %clear connection
            ef1.String='';
            ef3.String='';
            ef4.String='';
            ef5.String='';
            AIpmid.String='';
            AIDOI.String='';
            AItaxCommon.String='';
            AItaxSci.String='';
            AItaxID.String='';
            for j = 1:length(dataset)
                if 1==strcmp(currentChildPMID.String,dataset(j).articleInformation.PMID)
                    currentChildMLnr.String=string(j);
                end
            end
            if strcmp(bg.SelectedObject.String,'Article information')==1
                MLnr=str2double(currentChildMLnr.String);
                textAItitle.String = dataset(MLnr).title;
                if 0 == isfield(dataset,'articleInformation')
                    dataset(MLnr).articleInformation = [];
                end
                if isfield(dataset(MLnr).articleInformation,'PMID')
                    AIpmid.String = dataset(MLnr).articleInformation.PMID;
                end
                if isfield(dataset(MLnr).articleInformation,'DOI')
                    AIDOI.String = dataset(MLnr).articleInformation.DOI;
                end
                if isfield(dataset(MLnr).articleInformation,'taxName')
                    AItaxCommon.String = dataset(MLnr).articleInformation.taxName;
                end
                if isfield(dataset(MLnr).articleInformation,'taxSciName')
                    AItaxSci.String = dataset(MLnr).articleInformation.taxSciName;
                end
                if isfield(dataset(MLnr).articleInformation,'taxID')
                    AItaxID.String = dataset(MLnr).articleInformation.taxID;
                end
                articleInfo.Visible = 'on';
            end
        end
    end
end




