%% Loading and preparing the Data
clear all
load('Stimuli_raw.mat')

% Setting Stimulus properties
rampdur   = 100;
stimdur   = 700;
maskdur   = 500;
stimfreq  = 30;
tRes = 1;


%% Transforming Stimuli by transforming every pin 
       
stimulus = zeros(4,4,701);
for a = 1:200
    for b = 1:3
        for i = 1:4
            for j = 1:4
                pinhub = stimuli{a,b}(i,j);

                modulation = [(0:pinhub/rampdur:pinhub) ones(1,499)*pinhub (pinhub:-pinhub/rampdur:0)];

                timecourse = [(sin( (0:((((stimdur)./1000)*stimfreq)*2*pi)./((stimdur)./tRes):((((stimdur)./1000)*stimfreq)*2*pi) )+1)./2)];
                timecourse = timecourse + 0.5;

                stimulus(i,j,:) = modulation.*timecourse;
            end
        end
        transformed{a,b} = stimulus;
        clear stimulus
    end        
end


% Creating the mask
%mask = zeros(4,4,501);
for i = 1:4
    for j = 1:4
        pinhub = 1;

        modulation = [(0:pinhub/rampdur:pinhub) ones(1,299)*pinhub (pinhub:-pinhub/rampdur:0)];

        timecourse = [(sin( (0:((((maskdur)./1000)*stimfreq)*2*pi)./((maskdur)./tRes):((((maskdur)./1000)*stimfreq)*2*pi) )+1)./2)];
        timecourse = timecourse + 0.5;

        mask(i,j,:) = modulation.*timecourse;
    end
end

transformed{201,1} = mask;



%plot(squeeze(mask(1,1,:))); hold on; plot(squeeze(mask(1,2,:)));

%plot(squeeze(transformed{1,1}(1,1,:))); hold on; plot(squeeze(transformed{2,2}(2,2,:)));

save Stimuli_transformed.mat transformed
