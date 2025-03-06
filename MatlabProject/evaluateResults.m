%Έλεγχος αποτελεσμάτων
function fit=evaluateResults(chromosome,generation,numGenerations)
    numGaussians=size(chromosome.data,1);
    w=chromosome.data(:,1);
    c1=chromosome.data(:,2);
    c2=chromosome.data(:,3);
    sigma1=chromosome.data(:,4);
    sigma2=chromosome.data(:,5);

    %To fit στην περιοχή εισόδου που έχουμε
    startingFit=chromosome.fit;
    %Αξιολόγηση αποτελέσματος σύμφωνα με τα σημεία:
    num_points=50;
    u1=linspace(-4,-1,num_points);
    u2=linspace(2,4,num_points);

    %Συνδυασμός σημείων (κάθε σειρά είναι μια είσοδος)
    u=[u1',u2'];
    %Ανακάτεμα έτσι ώστε οι είσοδοι να είναι σχετικά τυχαίοι συνδυασμοί
    shuffled_indices=randperm(num_points);
    u1_shuffled=u(shuffled_indices,1);
    u=[u1_shuffled,u(:,2)];
    %Υπολογισμός εξόδου για κάθε είσοδο σύμφωνα με το μοντέλο υπολογισμού
    estimation=zeros(size(u,1),1);
    for j=1:size(u,1)
        for i=1:numGaussians
            estimation(j)=estimation(j)+w(i)*exp(-((u(j,1)-c1(i))^2/(2*sigma1(i)^2)+(u(j,2)-c2(i))^2/(2*sigma2(i)^2)));
        end
    end

    %Η δοσμένη έξοδος
    output=sin(u(:,1)+u(:,2)).*sin(u(:,2).^2);

    %1. Πόσο κοντά είναι η πραγματική έξοδος με αυτήν που υπολογίστηκε
    approachScore=1-mean(abs(output-estimation));
    %Επειδή οι έξοδοι είναι στο διάστημα [-1,1] αν η διαφορά της πραγματικής εξόδου με αυτήν 
    %που υπολογίστηκε είναι >1 τότε approachScore=0
    approachScore=max(approachScore,0);
    
    %2. Πόσους όρους έχουμε
    numZeroWeights=sum(w==0);
    zeroWeightScore=numZeroWeights/numGaussians;

    %Συνδυασμός των κριτηρίων για αξιολόγηση (βέλτιστο -> 1)
    weightCoefficient=0.3; %Ο αριθμός των Gaussian όρων συμβάλλει στο 30%
    fit=(1-weightCoefficient)*approachScore+weightCoefficient*zeroWeightScore;

    %3. Σε πόσες γενιές βρέθηκε
    generationScore=1-generation/numGenerations;

    %Συνδυασμός των κριτηρίων για αξιολόγηση (βέλτιστο -> 1)
    generationCoefficient=0.1; %Ο αριθμός των Gaussian όρων συμβάλλει στο 30%
    newFit=(1-weightCoefficient-generationCoefficient)*approachScore+weightCoefficient*zeroWeightScore+generationCoefficient*generationScore;

    %Εμφάνιση αποτελεσμάτων
    fprintf("Γραμμικός συνδυασμός γκαουσιανών συναρτήσεων:\n")
    fprintf("f~=")
    pluscounter=0;
    for i=1:numGaussians
        if w(i)~=0 && pluscounter==0
            fprintf("e^(-((u1-(%f))^2/%f+(u2-(%f))^2/%f)", c1(i),2*sigma1(i)^2,c2(i),2*sigma2(i)^2)
            pluscounter=1;
        elseif  w(i)~=0 && pluscounter~=0
            fprintf("+e^(-((u1-(%f))^2/%f+(u2-(%f))^2/%f)", c1(i),2*sigma1(i)^2,c2(i),2*sigma2(i)^2)
        end

    end
    fprintf("\n------------------------------------\n")
    fprintf("Αξιολόγηση αποτελέσματος:\n")
    fprintf("Βέλτιστο αποτέλεσμα fit->1, χείριστο αποτέλσμα fit->0\n")
    fprintf("Το fit στην περιοχή εισόδου που δόθηκε: %f\n", startingFit)
    fprintf("Το fit σε άλλη περιοχή εισόδου: %f\n", fit)
    fprintf("Το fit σε άλλη περιοχή εισόδου(συμπεριλαμβανομένου αριθμού γενεών): %f\n", newFit)
    fprintf("Βρέθηκε στην γενιά: %d/%d\n", generation,numGenerations)
end