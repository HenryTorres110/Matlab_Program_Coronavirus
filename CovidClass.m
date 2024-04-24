classdef CovidClass
    %COVIDCLASS Summary of this class goes here
    %   Detailed explanation goes here
    properties
        Country
        Country_I
        Dates
        States
        CovidTable
        State_I
    end
    methods
      
        function obj = CovidClass(input)
            load covid_data.mat covid_data; 
            obj.CovidTable=covid_data; 
            obj.Country=covid_data(:,1); 
            obj.Country{1}='Global'; 
            [~,t]=size(covid_data);
            obj.Dates=zeros(1,t-2);
            for pp=1:t-2
                    obj.Dates(1,pp)=datenum(covid_data{1,pp+2}, 'm/dd/yy');
            end
            [~,n]=ismember(obj.Country, input); 
            [~,obj.Country_I]=max(n);
            obj.State_I=obj.Country_I:(obj.Country_I+sum(n)-1);
            obj.States=covid_data(obj.State_I,2); 
            obj.States{1}='All'; 
        end
         function obj=daily_cases_deaths(obj,in_country, in_state)
             if strcmp(in_state,'All') && ~strcmp(in_country,'Global')
                daily_vector=zeros(1, length(obj.CovidTable)-2);
                daily_deaths=daily_vector;
                for ii=1:length(obj.CovidTable)-2
                    daily_vector(1,ii)=obj.CovidTable{obj.State_I(1),ii+2}(1,1);
                    daily_deaths(1,ii)=obj.CovidTable{obj.State_I(1),ii+2}(1,2);
                end
             elseif strcmp(in_country,'Global')
                 [r, c]=size(obj.CovidTable);
                 dailyc_global=zeros(r-1,c-2);
                 dailyd_global=zeros(r-1,c-2);
                 for ii=1:r-1
                     for jj=1:c-2
                         dailyc_global(ii,jj)=obj.CovidTable{ii+1,jj+2}(1,1);
                         dailyd_global(ii,jj)=obj.CovidTable{ii+1,jj+2}(1,1);
                     end
                 end
                 daily_vector=sum(dailyc_global);
                 daily_deaths=sum(dailyd_global);
             else
                 daily_vector=zeros(1, length(obj.CovidTable)-2);
                 daily_deaths=daily_vector;
                 for jj=1:length(obj.States)
                       if strcmp(in_state,obj.States{jj,1})
                           break;
                       end
                 end
                 for ii=1:length(obj.CovidTable)-2
                    daily_vector(1,ii)=obj.CovidTable{obj.State_I(jj),ii+2}(1,1);
                    daily_deaths(1,ii)=obj.CovidTable{obj.State_I(jj),ii+2}(1,2);
                 end
             end %%% End if
             auxiliar_vector=daily_vector;
             auxiliar_deaths=daily_vector;
             auxiliar_vector(1,1)=daily_vector(1,1);
             auxiliar_deaths(1,1)=daily_deaths(1,1);
             for jj=2:length(obj.CovidTable)-2
                 last_case=daily_vector(1,jj-1);
                 new_case=daily_vector(1,jj);
                 auxiliar_vector(1,jj)=new_case-last_case;
                 last_death=daily_deaths(1, jj-1);
                 new_death=daily_deaths(1,jj);
                 auxiliar_deaths(1,jj)=new_death-last_death;
             end
             obj=[auxiliar_vector; auxiliar_deaths];
         end %% End function
        function obj=sum_global_cases(obj)
            [r, c]=size(obj.CovidTable);
            data=zeros(r-1,c-2);
            for ii=1:r-1
                for jj=1:c-2
                    data(ii,jj)=obj.CovidTable{ii+1,jj+2}(1,1);
                end
            end
            obj=sum(data);
        end % function end
        function obj=sum_global_deaths(obj)
            [r,c]=size(obj.CovidTable);
            data_deaths=zeros(r-1,c-2);
            for ii=1:r-1
                for jj=1:c-2
                    data_deaths(ii,jj)=obj.CovidTable{ii+1,jj+2}(1,2);
                end
            end
            obj=sum(data_deaths);
        end
        function obj=CumulativeCases(obj,in_value)
            [~, p]=ismember(obj.States, in_value);
            [~,h]=max(p);
            cc_vector=zeros(1, length(obj.CovidTable)-2);
            for ii=1:length(obj.CovidTable)-2
                cc_vector(1,ii)=obj.CovidTable{obj.State_I(h), ii+2}(1,1);
            end
            obj=cc_vector;
        end % function end
        function obj=DeathCases(obj,in_value)
            [~, p]=ismember(obj.States, in_value);
            [~,h]=max(p);
            dc_vector=zeros(1, length(obj.CovidTable)-2);
            for jj=1:length(obj.CovidTable)-2
                dc_vector(1,jj)=obj.CovidTable{obj.State_I(h),jj+2}(1,2);
            end
            obj=dc_vector; 
        end % function end
    end
end

