%Selection: Επιλογή γονέων
function parents=selectParents(chromosome)
    populationSize=size(chromosome,2);
    parents=cell(1, populationSize);
    %Τοποθέτηση της αξιολόγησης κάθε χρωμοσώματος σε έναν πίνακα
    fitarray=zeros(1,populationSize);
    for i=1:populationSize
        fitarray(i)=chromosome{i}.fit;
    end
    %Τυχαία επιλογή γονέων με βάρος πιθανότητας την καλύτερη προσαρμογή
    selectedIndices=randsample(populationSize, populationSize, true, fitarray);
    for i=1:populationSize
       parents{i}=chromosome{selectedIndices(i)};
    end
end