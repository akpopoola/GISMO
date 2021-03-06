function plotpm(TC, bool_inc_az);

%PLOTPM Plot particle motion coefficients.
% PLOTPM(TC) Plot the particple motion coefficients from threecompcomp
% object TC. 
%

if numel(TC)>1
    error('Threecomp:plotpm:tooManyObjects', ...
        ['Plot only operates on a single threecomp object. ' ...
        'Select a single object using an index such as TC(n).']);
end

if get(TC,'COMPLETENESS')~=2
    error('Threecomp:plotpm:emptyFields','Necessary threecomp fields are not filled');
end
    
    
figure('Position',[50 0 900 1200],'Color','w');
set(gcf,'DefaultLineLineWidth',1);

if ~exist('bool_inc_az','var')
    bool_inc_az = false;
end
if bool_inc_az
    numax = 6;
else
    numax = 4;
end

% plot Z, N, E
subplot(numax/2,1,1);
scale = 0.75;
D = double(TC.traces(1:3));
normval = max(max(abs(D)));
D = scale * D./normval;			% do not normalize trace amplitudes
t = get(TC.traces(1),'timevector'); 
t = (t-t(1))*86400;
hold on; box on;
plot(gca,t,D(:,1)+1,'-','Color',[0 0 0.3]);
plot(gca,t,D(:,2)+0,'-','Color',[0 0.3 0]);
plot(gca,t,D(:,3)-1,'-','Color',[0.3 0 0]);
ylim(gca,[-1-scale 1+scale]);
xlabel(gca,'Seconds');
title(gca,['Station: ' get(TC.traces(1),'station') '   Starting at ' datestr(get(TC.traces(1),'start'),'yyyy/mm/dd HH:MM:SS.FFF') ]);
set(gca,'YGrid','on'); set(gca,'XGrid','on');
set( gca , 'YTick' , [-1:1] );
set( gca , 'YTickLabel' , fliplr(get(TC.traces,'CHANNEL')) );
%
% set title
titlestr = (['Station: ' get(TC.traces(1),'station') '      Starting at ' datestr(get(TC.traces(1),'start'),'yyyy/mm/dd HH:MM:SS.FFF')]);
% orid = num2str(get(TC.traces(1),'ORIGIN_ORID'));
% if ~isempty(orid)
%     titlestr = [titlestr '      orid: ' orid];
% end
title(gca,titlestr,'FontSize',14);
xlim=get(gca,'XLim');

% plot energy
subplot(numax,1,3);
plot(TC.energy,'k-','axeshandle',gca);
set(gca,'YScale','linear');
d = get(TC.energy,'Data');
ylim(gca,[0 1.1*max(d)]);
legend(gca,'Energy');
title(gca,'');
%set(gca,'XTickLabel',[]);
set(gca,'XGrid','on')
set(gca,'XLim',xlim)

% plot rectilinearity and planarity
subplot(numax,1,4);
plot(TC.rectilinearity,'kx','axeshandle',gca);
hold on;
plot(TC.planarity,'ko','MarkerFaceColor','y','axeshandle',gca);
xlabel(gca,'Seconds');
ylim(gca,[0 1]);
legend(gca,'Rectilinearity','Planarity');
title(gca,'');
%set(gca,'XTickLabel',[]);
set(gca,'XGrid','on')
set(gca,'XLim',xlim)

if bool_inc_az

    % plot azimuth
    subplot(6,1,5);
    plot(TC.azimuth,'ko','MarkerFaceColor',[1 .7 0],'axeshandle',gca);
    set(gca,'YTick',[-360:90:360]);
    ylim(gca,[-1 361]);
    xlabel(gca,'')
    legend('Azimuth');
    title(gca,'');
    set(gca,'XTickLabel',[]);
    set(gca,'XGrid','on')
    set(gca,'XLim',xlim)

    % plot inclination
    subplot(6,1,6);
    plot(TC.inclination,'ko','MarkerFaceColor',[1 .7 0],'axeshandle',gca);
    set(gca,'YTick',[-90:30:90]);
    ylim(gca,[-1 91]);
    xlabel(gca,'')
    legend(gca,'Inclination');
    title(gca,'');
    set(gca,'XGrid','on')
    set(gca,'XLim',xlim)

end

set(gcf, 'paperorientation', 'portrait');
set(gcf, 'paperposition', [.25 .5 8 10] );
%print(gcf, '-depsc2', ['tmp.ps']);

