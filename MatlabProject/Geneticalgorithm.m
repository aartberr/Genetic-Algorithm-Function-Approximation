clc; clear;
%Αρχικοποίηση
populationSize=200;
numGenerations=100;
numGaussians=15;
numParameters=5;
sizeChromosome=[numGaussians numParameters];
goodfit=0.85;
mutationRate=0.02;
%Διαστήματα παραμέτρων
c1Interval=[-1 2];
c2Interval=[-2 1];
sigmaInterval=[0.1 1];

%Παράμετροι χρωμοσώματος & τυχαία αρχικοποίηση πληθυσμού
%Για την μεταβλητή chromosome:
chromosome=cell(1, populationSize);
for i=1:populationSize
  chromosome{i}.data=zeros(sizeChromosome); 
  %1η στήλη: συντελεστής κάθε Gaussian όρου 0 ή 1
  chromosome{i}.data(:,1)=round(rand([numGaussians 1]));
  %2η στήλη: c1 κάθε Gaussian όρου από [-1,2]
  chromosome{i}.data(:,2)=c1Interval(1)+rand([numGaussians 1])*(c1Interval(2)-c1Interval(1));
  %3η στήλη: c2 κάθε Gaussian όρου από [-2,1]
  chromosome{i}.data(:,3)=c2Interval(1)+rand([numGaussians 1])*(c2Interval(2)-c2Interval(1));
  %4η στήλη: σ1 κάθε Gaussian όρου από [0.1,1]
  %5η στήλη: σ2 κάθε Gaussian όρου από [0.1,1]
  chromosome{i}.data(:, 4:5)=sigmaInterval(1)+rand([numGaussians 2])*(sigmaInterval(2)-sigmaInterval(1)); 
  %fit: πόσο βέλτιστο είναι κάθε χρωμόσωμα
  chromosome{i}.fit=0;
end

bestFit=0;
%Γενετικός αλγόριθμος
for generation = 1:numGenerations
    %Έλεγχος για την αποτελεσματικότητα του χρωμοσώματος
    for i=1:populationSize
        chromosome{i}.fit=evaluateFitness(chromosome{i});
        if chromosome{i}.fit>=goodfit
            bestFit=i; %Αν βρέθει πολύ καλή λύση σταματάμε να ψάχνουμε
            break;
        end
    end

    %Έξοδος από τον βρόχο αν έχει βρέθει βέλτιστη λύση
    if bestFit~=0 
        break;
    end

    %Selection:Επιλογή γονέων
    parents=selectParents(chromosome);

    %Crossover:Διάσταύρωση
    offspring=crossover(parents);

    %Mutation:Μετάλλαξη απογόνων
    offspring=mutate(offspring, mutationRate);

    %Ο νέος πληθυσμός χρωμοσωμάτων γίνεται με βάση το καλύτερο fit από όλα
    %τα χρωμοσώματα
    chromosome=newpopulation(chromosome, offspring);
end

%Έλεγχος για την αποτελεσματικότητα του τελευταίου χρωμοσώματος
if bestFit==0 
    lastfit=zeros(1,populationSize);
    for i=1:populationSize
        chromosome{i}.fit=evaluateFitness(chromosome{i});
        lastfit(i)=chromosome{i}.fit;
        if chromosome{i}.fit>=goodfit
            bestFit=i; %Αν βρέθει πολύ καλή λύση σταματάμε να ψάχνουμε
            break;
        end
    end
end

%Αν δεν έχει βρεθεί κάποιο χρωμόσωμα που να ικανοποιεί το κριτήριο καλής
%προσαρμογής
if bestFit==0 
   [~,bestFit]=max(lastfit);
end

%Ο καλύτερος γραμμικός συνδιασμός των γκαουσιανών προκύπτει από 
%τα στοιχεία του καλύτερου χρωμοσώματος
bestChromosome=chromosome{bestFit};
evaluateResults(bestChromosome, generation, numGenerations);
