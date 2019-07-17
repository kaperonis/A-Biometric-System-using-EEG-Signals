% TO BE RESOLVED

        clear;                                                                    %--------------- OK
        clc;                                                                      %--------------- OK
        tic;
        Nruns = 6;
        Nsubj = 109;                                                              %--------------- OK 
         
        dataset = read_dataset_preprocessing_EO();                                %--------------- OK      
        dataset = remove_unused_channels_region_F(dataset,Nsubj);                          %--------------- OK      
        input_dataset_size = size(dataset);
        Nel = input_dataset_size(2);              
        Nvalues = 40;                                      
        dataset = segmetation(dataset, Nsubj, Nel);                                    %--------------- OK 

        PSD = zeros(Nruns, Nsubj, Nel, Nvalues);

        for j=1:Nruns
                [PSD(j,:,:,:)] = log10(PSD_feature_extraction(squeeze(dataset(j,:,:,:)),Nsubj, Nel, Nvalues));
        end
        %coh_time = toc;
        [covariance_matrix_PSD] = covariance_calculation_PSD(PSD, Nruns, Nsubj, Nel, Nvalues);
        tic;
        [mahalanobis_distance_PSD,CRR_PSD] = mahalanobis_distance_calculation_PSD(PSD, Nruns, Nsubj, Nel, Nvalues, covariance_matrix_PSD);

        surf(CRR);
        mCRR = mean(CRR_PSD,2);
        [mCRRval,mCRRind] = sort(mCRR,1);
        [fusion] = fusion_algorithm(CRR,mahalanobis_distance_PSD,mCRRind,mCRRval);
        time_elapsed = toc;
        %clearvars -except myVars USEFULL COMMAND FOR DELETING VARS BUT NOT THE WHOLE WORKSPACE
%end