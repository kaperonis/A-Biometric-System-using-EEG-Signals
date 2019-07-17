%function [CRR_COH_EO,CRR_COH_EC,CRR_PSD_EO, CRR_PSD_EC] = main()
        clear;                                                                    %--------------- OK
        clc;                                                                      %--------------- OK
        tic;
        Nruns = 6;
        Nsubj = 109;                                                              %--------------- OK 
         
        dataset = read_dataset_preprocessing_EO();                                %--------------- OK      
        dataset = remove_unused_channels(dataset,Nsubj);                          %--------------- OK      
        input_dataset_size = size(dataset);
        Nel = input_dataset_size(2);              
        Nvalues = 40;                                      
        dataset = segmetation(dataset, Nsubj, Nel);                                    %--------------- OK 

        Nel_comb = nchoosek(Nel,2); 

        COH = zeros(Nruns, Nsubj, Nel_comb, Nvalues);
        %PSD = zeros(Nruns, Nsubj, Nel, Nvalues);

        for j=1:Nruns
                [COH(j,:,:,:)] = atanh(COH_feature_extraction(squeeze(dataset(j,:,:,:)), Nsubj, Nel, Nvalues));        
        end
        %coh_time = toc;
        tic;
        CRR_COH = zeros(6,Nel_comb);
        mahalanobis_distance_COH = zeros(Nruns, Nel_comb, Nsubj, Nsubj);
        for j=1:Nruns
                [covariance_matrix_COH] = covariance_calculation_COH(COH,Nruns, Nsubj, Nel_comb, Nvalues, mean(COH),j);
                [mahalanobis_distance_COH(i,:,:,:), CRR_COH(j,:)] = mahalanobis_distance_calculation_COH(COH, Nruns, Nsubj, Nel_comb, Nvalues, covariance_matrix_COH,j);
        end
        CRR_estimation_time = toc;

        surf(CRR);
        mCRR = mean(CRR_COH,2);
        [mCRRval,mCRRind] = sort(mCRR,1);
        [fusion] = fusion_algorithm(CRR_COH,mahalanobis_distance_COH,mCRRind,mCRRval);
        time_elapsed = toc;
        %clearvars -except myVars USEFULL COMMAND FOR DELETING VARS BUT NOT THE WHOLE WORKSPACE
%end