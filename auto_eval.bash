#!/bin/bash
############################################################################################################################
# COMMON LIB
############################################################################################################################
function ae_echo_ ()
{
    echo $* | tee -a ${LOGFILE}
}
############################################################################################################################
function read_an_answer_ ()
{
    read_an_answer_n="$1";
    shift
    read_an_answer_s=`echo -n "Type your choice ( "
    for read_an_answer_c in $* ;
    do
       echo -n \$read_an_answer_c" ";
    done
    echo  -n ") : "`
    read_an_answer_continue=1;
    while [ $read_an_answer_continue -eq 1 ]
    do
        ae_echo_ -n $read_an_answer_s
        read read_an_answer_v; 
        if [ $LOGYN -eq 1 ]
        then
            echo $read_an_answer_v >> ${LOGFILE}
        fi
        for read_an_answer_c in $* ;
        do
            if [ "$read_an_answer_c" = "$read_an_answer_v" ]
            then
                read_an_answer_continue=0;
                break;
            fi
        done
        if [ $read_an_answer_continue -eq 1 ]
        then
            ae_echo_ "Wrong answer "$read_an_answer_v
        fi
    done
    eval $read_an_answer_n=$read_an_answer_v;
    ae_echo_ -e "\n"
}
############################################################################################################################
function msg_ ()
{

cat << msg_EOFi | tee -a ${LOGFILE}

===============================================================================
msg_EOFi

case $1 in
    1)
    cat << msg_EOF1 | tee -a ${LOGFILE} ;;
Warning : $2
If from message above you have a solution, fix problems in an other terminal.
And afterward chose again to do an archive in the menu
msg_EOF1
    2)
    cat << msg_EOF2 | tee -a ${LOGFILE} ;;
Error : $2
If from message above you have a solution, fix problems in an other terminal.
And afterward choose again to do an archive in the menu
msg_EOF2
    3)
    cat << msg_EOF3 | tee -a ${LOGFILE} ;;
Error :  $2
Try to fix problem or contact teachers.
msg_EOF3
    4)
    cat << msg_EOF4 | tee -a ${LOGFILE} ;;
$2
msg_EOF4
    5)
    cat << msg_EOF5 | tee -a ${LOGFILE} ;;
$2
$3
msg_EOF5
    6)
    cat << msg_EOF6 | tee -a ${LOGFILE} ;;
$2
$3
$4
msg_EOF6
    7)
    cat << msg_EOF7 | tee -a ${LOGFILE} ;;
Warning : $2
msg_EOF7
    8)
    cat << msg_EOF8 | tee -a ${LOGFILE} ;;
Error : $2
msg_EOF8
    esac

cat << msg_EOFi | tee -a ${LOGFILE}
===============================================================================

msg_EOFi
}
############################################################################################################################
function nb_ligne_ ()
{
        eval $1=`cat $2 | wc -l | cut -d' ' -f1`
}
############################################################################################################################
function clean_tmpdir_ ()
{
if [ -d $TMPDIR ]
then
    rm -rf $TMPDIR
fi
}
############################################################################################################################
function clean_autodir_ ()
{
if [ -d $AUTODIR ]
then
    msg_ 7 "Cleaning"
    cat<<clean_autodir_EOF1 | tee -a ${LOGFILE}
Do you want to clean (c) or save (s) temporary folder $AUTODIR ?
This folder may contain compilation, execution and evaluation of last evaluated archive.
If you save it, it's your responsability to do the cleaning

clean_autodir_EOF1
    read_an_answer_ clean_autodir_A c s
    if [ "$clean_autodir_A" = c ]
    then
        rm -rf $AUTODIR
    fi
fi
}
############################################################################################################################
function eval_arch_check_ ()
{
if [ -z "$EVALARCH" ]
then
    EVALARCH="${TARFILE}_${GROUP_ID}.tar.gz"
    msg_ 6 "Name of archive must be $EVALARCH" "If it's not the case change it in an other terminal" \
           "And afterward choose again to evaluate an archive in the menu"
fi
eval_arch_check_EVALARCH=`basename $EVALARCH`;
msg_ 4 "Checking archive $eval_arch_check_EVALARCH "
ae_echo_ "Looking for archive"
if [ -f $EVALARCH -a -s $EVALARCH ]
then
    ae_echo_ "Archive found and is a non null regular file"
    gzip -t $EVALARCH >& /dev/null
    if [ $? -eq 0 ]
    then
        ae_echo_ "Archive is in gz compressed format"
        tar tzf $EVALARCH >& /dev/null
        if [ $? -eq 0 ]
        then
            ae_echo_ "Archive is in tar format"
            ae_echo_ "Archive is present and in correct format";
            return 0
        else
            msg_ 8 "File $eval_arch_check_EVALARCH is not in correct tar format";
        fi
    else
        msg_ 8 "File $eval_arch_check_EVALARCH is not in gz compressed format";
    fi
else
    msg_ 8 "File $eval_arch_check_EVALARCH is missing or a null regular file";
fi
return 1
}
############################################################################################################################
function eval_arch_genrep_ ()
{
msg_ 4 "Generate folder"
if [ -d $AUTODIR ]
then
    rm -rf $AUTODIR
fi
mkdir $AUTODIR
if [ $? -eq 0 ]
then
    ae_echo_ "$AUTODIR directory created."
    cd $AUTODIR
    return 0
else
    ae_echo_ "Impossible to create $AUTODIR directory"
    return 1
fi
}
############################################################################################################################
function eval_arch_unpack_ ()
{
msg_ 4 "Unpacking archive $EVALARCH"
if [ -f .unpack_ok ]
then
    rm .unpack_ok
    rm -f .nb_compil
    rm -f .nb_compil_scale
    rm -f .nb_run
    rm -f .nb_run_scale
fi
tar xzf $CURDIR/$EVALARCH
if [ $? -eq 0 ]
then
    ae_echo_ "Archive correctly extracted"
    if [ -s ${TMPDIR}/fts ]
    then
        msg_ 4 "Adding teacher's file"
        for eval_arch_unpack_f in `cat ${TMPDIR}/fts`
        do
            if [ -s ${TMPDIR}/$eval_arch_unpack_f ]
            then
                cp -f ${TMPDIR}/$eval_arch_unpack_f .
                ae_echo_ "Adding $eval_arch_unpack_f"
            else
                msg_ 3 "Teacher file ${TMPDIR}/$eval_arch_unpack_f not here or null ???"
                return 1
            fi
        done
        touch .unpack_ok
        return 0
    fi
else
    msg_ 8 "Impossible to unpack archive"
    return 1
fi
}
############################################################################################################################
function eval_arch_compil_ ()
{
eval_arch_compil_DO=1;
if [ -f .nb_compil ]
then
    eval_arch_compil_COK=`ls *.cc *.h .nb_compil -rtla 2>/dev/null | sed -n '$p' | grep -c ".nb_compil"`
    if [ $eval_arch_compil_COK -eq 1 ]
    then
        eval_arch_compil_NC=`cat .nb_compil`
        if [ $eval_arch_compil_NC -eq $NBEXE ]
        then
            eval_arch_compil_DO=0;
        else
            rm .nb_compil
            rm .nb_compil_scale
        fi
    else
        rm .nb_compil
        rm .nb_compil_scale
    fi
fi
if [ $eval_arch_compil_DO -eq 1 ]
then
    if [ -f .unpack_ok ]
    then
        msg_ 4 "Compile archive $EVALARCH"

        eval_arch_compil_K=0;
        eval_arch_compil_KT=0;
        eval_arch_compil_KS=0;
        for ((eval_arch_compil_i=1;eval_arch_compil_i<=NBEXE;++eval_arch_compil_i))
        do
            eval_arch_compil_EXE='';
            eval_arch_compil_F=`sed -n $eval_arch_compil_i'p' $TMPDIR/list_of_ex`
            eval_arch_compil_F1=`echo $eval_arch_compil_F | cut -f1 -d' '`;
            eval_arch_compil_NOPOINT=`echo $eval_arch_compil_F | grep -c '###'`;
            eval_arch_compil_SCALE=`sed -n $eval_arch_compil_i'p' $TMPDIR/list_of_ex_coef`
            eval_arch_compil_W=`echo $eval_arch_compil_F| wc -w`
            if [ $eval_arch_compil_W -gt 1 ]
            then
                if [ -f list_o_$$ ]
                then
                    rm list_o_$$;
                fi
                for eval_arch_compil_C in `echo $eval_arch_compil_F`
                do
                    if [ -f ${eval_arch_compil_C}*.cc ]
                    then
                        if [ -f ${eval_arch_compil_C}.o ]
                        then
                            rm ${eval_arch_compil_C}.o
                        fi
                        g++ -std=c++98 ${eval_arch_compil_C}.cc -c -o ${eval_arch_compil_C}.o >& /dev/null;
                        if [ $? -ne 0 ]
                        then
                            ae_echo_ "Problem : ${eval_arch_compil_C}.cc didn't compile correctly"
                        else
                            ae_echo_ "${eval_arch_compil_C}.cc compile correctly"
                        fi
                        echo "${eval_arch_compil_C}.o" >> list_o_$$
                    fi
                done
                if [ -s list_o_$$ ]
                then
                    eval_arch_compil_EXE=`cat list_o_$$`;
                    rm list_o_$$;
                fi
            else
                if [ -f ${eval_arch_compil_F}.cc ]
                then
                    eval_arch_compil_EXE=${eval_arch_compil_F}.cc;
                fi
            fi
            if [ -x $eval_arch_compil_F1 ]
            then
                rm $eval_arch_compil_F1
            fi
            if [ `echo $eval_arch_compil_EXE|wc -w` -gt 0 ]
            then
                g++ -std=c++98 $eval_arch_compil_EXE -o $eval_arch_compil_F1 >& /dev/null;
                if [ $? -eq 0 ]
                then
                    ae_echo_ "Program ${eval_arch_compil_F1} compile correctly"
                    if [ $eval_arch_compil_NOPOINT -lt 1 ]
                    then
                        echo $((eval_arch_compil_K++))>>/dev/null;
                        echo $((eval_arch_compil_KS=eval_arch_compil_KS+eval_arch_compil_SCALE))>>/dev/null;
                    fi
                    echo $((eval_arch_compil_KT++))>>/dev/null;
                else
                    ae_echo_ "Problem : program ${eval_arch_compil_F1} didn't compile correctly"
                fi
                ls ${eval_arch_compil_F1}_*.res >& /dev/null
                if [ $? -eq 0 ]
                then
                    rm ./${eval_arch_compil_F1}_*.res
                fi
            fi
        done
        if [ $eval_arch_compil_K -gt 0 ]
        then
            echo $eval_arch_compil_KS > .nb_compil_scale
        fi
        if [ $eval_arch_compil_KT -gt 0 ]
        then
            echo $eval_arch_compil_KT > .nb_compil
        fi
        return 0
    else
        msg_ 8 "No unpacked archive !! Compilation of $EVALARCH not possible"
        return 1
    fi
fi
}
############################################################################################################################
function eval_arch_run_ ()
{
eval_arch_run_DO=1;
if [ -f .nb_run ]
then
    eval_arch_run_EXELIST=`cat $TMPDIR/list_of_ex | cut -f1 -d' '`
    eval_arch_run_ROK=`ls $eval_arch_run_EXELIST .nb_run -rtla 2>/dev/null | sed -n '$p' | grep -c ".nb_run"`
    if [ $eval_arch_run_ROK -eq 1 ]
    then
        eval_arch_run_NR=`cat .nb_run`
        if [ $eval_arch_run_NR -eq $NBEXE ]
        then
            eval_arch_run_DO=0;
        else
            rm .nb_run
            rm .nb_run_scale
        fi
    else
        rm .nb_run
        rm .nb_run_scale
    fi
fi
if [ $eval_arch_run_DO -eq 1 ]
then
    if [ -f .nb_compil ]
    then
        msg_ 4 "Run archive $EVALARCH"

        eval_arch_run_K=0;
        eval_arch_run_KT=0;
        eval_arch_run_KS=0;
        for ((eval_arch_run_i=1;eval_arch_run_i<=NBEXE;++eval_arch_run_i))
        do
            eval_arch_run_EXE='';
            eval_arch_run_F1=`sed -n $eval_arch_run_i'p' $TMPDIR/list_of_ex | cut -f1 -d' '`
            eval_arch_run_NOPOINT=`sed -n $eval_arch_run_i'p' $TMPDIR/list_of_ex | grep -c '###'`;
            eval_arch_run_SCALE=`sed -n $eval_arch_run_i'p' $TMPDIR/list_of_ex_coef`
            eval_arch_run_L=0;
            eval_arch_run_M=0;
            if [ -x $eval_arch_run_F1 ]
            then
                ls $eval_arch_run_F1*.dat >& /dev/null
                if [ $? -ne 0 ]
                then
                    msg_ 3 "Configuration problem. No data file for $eval_arch_run_F1. Rebuilt "
                    return 1
                fi
                for eval_arch_run_DATA in `ls $eval_arch_run_F1*.dat`
                do
                    echo $((eval_arch_run_M++))>>/dev/null;
                    eval_arch_run_RES=`basename $eval_arch_run_DATA .dat`.res
                    { ./$eval_arch_run_F1 < $eval_arch_run_DATA  &> $eval_arch_run_RES; } 2> tmp_$$ 
                    if [ $? -eq 0 ]
                    then
                        ae_echo_ "Program ${eval_arch_run_F1} run correctly with $eval_arch_run_DATA"
                        echo $((eval_arch_run_L++))>>/dev/null;
                        rm tmp_$$
                    else
                        ae_echo_ "Problem : program ${eval_arch_run_F1} didn't run correctly with $eval_arch_run_DATA"
                        ae_echo_ "Error message is :"
                        cat tmp_$$ |sed 's/\.\/$eval_arch_run_F1 < $eval_arch_run_DATA &>$eval_arch_run_RES//' |\
                                    sed "s/$MYNAMESED: line [0-9][0-9][0-9]://"| tee -a ${LOGFILE}
                        rm tmp_$$
                   #     break;
                    fi
                done
                if [ $eval_arch_run_L  -eq $eval_arch_run_M ]
                then
                    if [ $eval_arch_run_NOPOINT -lt 1 ]
                    then
                        echo $((eval_arch_run_K++))>>/dev/null;
                        echo $((eval_arch_run_KS=eval_arch_run_KS+eval_arch_run_SCALE))>>/dev/null;
                    fi
                    echo $((eval_arch_run_KT++))>>/dev/null;
                fi
            fi
        done
        if [ $eval_arch_run_K -gt 0 ]
        then
            echo $eval_arch_run_KS > .nb_run_scale
        fi
        if [ $eval_arch_run_KT -gt 0 ]
        then
            echo $eval_arch_run_KT > .nb_run
        fi
        return 0
    else
        msg_ 8 "No full or partial compilation !! Running $EVALARCH not possible"
        return 1
    fi
fi
}
############################################################################################################################
function eval_arch_diff_ ()
{
if [ -f .nb_run ]
then
    eval_arch_diff_DO=1;
    if [ -f .nb_diff ]
    then
        eval_arch_diff_DOK=`ls *.res .nb_diff -rtla | sed -n '$p' | grep -c ".nb_diff"`
        if [ $eval_arch_diff_DOK -eq 1 ]
        then
            nb_ligne_ eval_arch_diff_ND .nb_diff
            if [ $eval_arch_diff_ND -eq 0 ]
            then
                eval_arch_diff_DO=0;
            else
                rm .nb_diff
            fi
        else
            rm .nb_diff
        fi
    fi
    if [ $eval_arch_diff_DO -eq 1 ]
    then
        msg_ 4 "Evaluate result of archive $EVALARCH"
        rm .nb_point >& /dev/null
        touch .nb_diff
        for ((eval_arch_diff_i=1;eval_arch_diff_i<=NBEXE;++eval_arch_diff_i))
        do
            eval_arch_diff_K=0;
            eval_arch_diff_L=0;
            eval_arch_diff_EXE='';
            eval_arch_diff_F1=`sed -n $eval_arch_diff_i'p' $TMPDIR/list_of_ex | cut -f1 -d' '`
            eval_arch_diff_NOPOINT=`sed -n $eval_arch_diff_i'p' $TMPDIR/list_of_ex | grep -c '###'`;
            eval_arch_diff_SCALE=`sed -n $eval_arch_diff_i'p' $TMPDIR/list_of_ex_coef`
            eval_arch_diff_NBPOINT_EXO=0;
            eval_arch_diff_NBPOINT_TOTAL=0;
            if [ -s $eval_arch_diff_F1.reg ]
            then
                nb_ligne_ eval_arch_diff_NBREG ${eval_arch_diff_F1}.reg
                for ((eval_arch_diff_j=1;eval_arch_diff_j<=eval_arch_diff_NBREG;++eval_arch_diff_j))
                do
                    eval_arch_diff_VP=`sed -n $eval_arch_diff_j'p' ${eval_arch_diff_F1}.reg | cut -d':' -f3`
                    eval_arch_diff_NBPOINT_TOTAL=`echo "scale=8; $eval_arch_diff_NBPOINT_TOTAL+$eval_arch_diff_VP" | bc -l `
                done
                for eval_arch_diff_DAT in `ls $eval_arch_diff_F1*.dat`
                do
                    echo $((eval_arch_diff_L++))>>/dev/null;
                    eval_arch_diff_M=0;
                    eval_arch_diff_NBPOINT_DAT=0;
                    eval_arch_diff_DATN=`basename $eval_arch_diff_DAT .dat|awk 'BEGIN{FS="_";}{print $NF}'`
                    eval_arch_diff_SOL=`basename $eval_arch_diff_DAT .dat`.sol
                    eval_arch_diff_RES=`basename $eval_arch_diff_DAT .dat`.res
                    if [ ! -s $eval_arch_diff_SOL ]
                    then
                        msg_ 3 "Configuration problem ! $eval_arch_diff_DAT present but not $eval_arch_diff_SOL"
                        break;
                    fi
                    if [ -s $eval_arch_diff_RES ]
                    then
                        for ((eval_arch_diff_j=1;eval_arch_diff_j<=eval_arch_diff_NBREG;++eval_arch_diff_j))
                        do
                            eval_arch_diff_VARN=`sed -n $eval_arch_diff_j'p' ${eval_arch_diff_F1}.reg | cut -d':' -f1`;
                            eval_arch_diff_REG="^[ ]*${eval_arch_diff_VARN}[ ]*:[ ]*"
                            eval_arch_diff_VT=`sed -n $eval_arch_diff_j'p' ${eval_arch_diff_F1}.reg | cut -d':' -f2`
                            eval_arch_diff_VP=`sed -n $eval_arch_diff_j'p' ${eval_arch_diff_F1}.reg | cut -d':' -f3`
                            eval_arch_diff_VC=`basename $eval_arch_diff_DAT .dat`_${eval_arch_diff_j}_COMP
                            eval_arch_diff_VS=`basename $eval_arch_diff_DAT .dat`_${eval_arch_diff_j}_SOL
                            if [ "$eval_arch_diff_VT" = "R" ]
                            then
                                sed -n $eval_arch_diff_j'p' ${eval_arch_diff_SOL} |  awk '{print $1*1.}' > $eval_arch_diff_VS
                            elif [ "$eval_arch_diff_VT" = "T" ]
                            then
                                sed -n $eval_arch_diff_j'p' ${eval_arch_diff_SOL} > $eval_arch_diff_VS
                            elif [ "$eval_arch_diff_VT" = "C" ]
                            then
                                sed -n $eval_arch_diff_j'p' ${eval_arch_diff_SOL} |  awk '{print $1*1.,$2*1.}' > $eval_arch_diff_VS
                            elif [ "$eval_arch_diff_VT" = "E" ]
                            then
                                sed -n $eval_arch_diff_j'p' ${eval_arch_diff_SOL} |  awk '{printf("%.15f %d\n", $1*1.,$2);}' > $eval_arch_diff_VS
                            else
                                msg_ 3 "Configuration problem. Some regular expretion in ${eval_arch_diff_F1}.reg  are of unknow type : $eval_arch_diff_VT"
                                return 1
                            fi
                            eval_arch_diff_GREP=`grep "$eval_arch_diff_REG" $eval_arch_diff_RES` 
                            if [ $? -eq 0 ]
                            then
                                eval_arch_diff_GREP_count=`grep -c "$eval_arch_diff_REG" $eval_arch_diff_RES`
                            else
                                eval_arch_diff_GREP_count=0
                            fi
                            if [ $eval_arch_diff_GREP_count -eq 1 ]
                            then
                                if [ "$eval_arch_diff_VT" = "R" ]
                                then
                                    echo $eval_arch_diff_GREP | awk -v e=$EPSILON_RES 'BEGIN{ FS=":";}{if ($2*1.<e && $2*1.>-e) print 0.; else print $2*1.;}' > $eval_arch_diff_VC
                                elif [ "$eval_arch_diff_VT" = "T" ]
                                then
                                    echo $eval_arch_diff_GREP | cut -d':' -f2- > $eval_arch_diff_VC
                                elif [ "$eval_arch_diff_VT" = "C" ]
                                then
                                    echo $eval_arch_diff_GREP | cut -d':' -f2- | sed 's/(//
                                                                                      s/)//
                                                                                      s/i//' | awk -v e=$EPSILON_RES 'BEGIN{ FS=",";}{if ($1*1.<e && $1*1.>-e ) r=0.; else r=$1*1.;if ($2*1.<e && $2*1.>-e ) i=0.; else i=$2*1.; print r,i}' > $eval_arch_diff_VC
#s/i//' | awk -v e=$EPSILON_RES 'BEGIN{ FS=",";e=1.e-10;}{if ($1*1.<e && $1*1.>-e ) r=0.; else r=$1*1.;if ($2*1.<e && $2*1.>-e ) i=0.; else i=$2*1.; print r,i}' > $eval_arch_diff_VC
                                elif [ "$eval_arch_diff_VT" = "E" ]
                                then
                                    echo $eval_arch_diff_GREP | cut -d':' -f2- | sed 's/E/ /' | awk '{printf("%.15f %d\n", $1*1.,$2);}' > $eval_arch_diff_VC
                                fi
                                if [ "$eval_arch_diff_VT" = "E" ]
                                then
                                    paste $eval_arch_diff_VC $eval_arch_diff_VS | awk -v e=$EPSILON_RES 'BEGIN{m=0.;p=0;d=0;m1=0.;m2=0.;e1=0;e2=0;}{
                                         d=$2-$4;
                                         m1=$1;m2=$3;
                                         e1=$2;e2=$4;
                                         if (d==1 || d==-1)
                                         {
                                             if (d>0)
                                             {
                                                 m2=m2/10.;
                                                 e2=e2+1;
                                             }
                                             else
                                             {
                                                 m1=m1/10.;
                                                 e1=e1+1;
                                             }
                                         }
                                         if (m2<e && m2>-e)
                                         {
                                             m=m1;
                                         }
                                         else
                                         {
                                             m=(m1-m2)/m2;
                                         }
                                         if (e2<e && e2>-e)
                                         {
                                             p=e1;
                                         }
                                         else
                                         {
                                             p=(e1-e2)/e2;
                                         }
                                     }END{if (m<e && m>-e && p<e && p>-e) print 1; else print 0;}' | grep -q '1';
                                else
                                     diff -b -w -a -q $eval_arch_diff_VC $eval_arch_diff_VS >> /dev/null
                                fi
                                if [ $? -ne 0 ]
                                then
                                    echo "$eval_arch_diff_VC $eval_arch_diff_VS : $eval_arch_diff_F1 $eval_arch_diff_DATN ${eval_arch_diff_VARN}" >> .nb_diff
                                    ae_echo_ "For $eval_arch_diff_DAT input parameter setting, program '$eval_arch_diff_F1' don't give correct result for ${eval_arch_diff_VARN} result."

                                else
                                    echo $((eval_arch_diff_M++))>>/dev/null;
                                    eval_arch_diff_NBPOINT_DAT=`echo "scale=8; ${eval_arch_diff_NBPOINT_DAT}+${eval_arch_diff_VP}" | bc -l `
                                fi
                            else
                                echo '' >$eval_arch_diff_VC
                                echo "$eval_arch_diff_VC $eval_arch_diff_VS : $eval_arch_diff_F1 $eval_arch_diff_DATN ${eval_arch_diff_VARN}" >> .nb_diff
                                ae_echo_ "For $eval_arch_diff_DAT input parameter setting, program '$eval_arch_diff_F1'  result ${eval_arch_diff_VARN} was not found."
                            fi
                        done
                        echo $((eval_arch_diff_K += $eval_arch_diff_M))>>/dev/null;
                        eval_arch_diff_NBPOINT_EXO=`echo "scale=8; ${eval_arch_diff_NBPOINT_DAT}+${eval_arch_diff_NBPOINT_EXO}" | bc -l `
                    else
                        ae_echo_ "For $eval_arch_diff_DAT input parameter setting, program '$eval_arch_diff_F1'  results where not found."
                    fi
                done
                if [ $eval_arch_diff_K -gt 0 ]
                then
                    eval_arch_diff_MRI=`echo "scale=0; $eval_arch_diff_K/$eval_arch_diff_L" | bc -l `
                    eval_arch_diff_MR=`echo "scale=2; $eval_arch_diff_K/$eval_arch_diff_L" | bc -l `
                    if [ $eval_arch_diff_NOPOINT -lt 1 ]
                    then
                        eval_arch_diff_NBPOINT_EXO_moy=`echo "scale=8; $eval_arch_diff_SCALE*$eval_arch_diff_NBPOINT_EXO/$eval_arch_diff_L" | bc -l `
                    else
                        eval_arch_diff_NBPOINT_EXO_moy=`echo "scale=8; $eval_arch_diff_SCALE*$eval_arch_diff_NBPOINT_EXO*6./($eval_arch_diff_L*4.)" | bc -l `
                    fi
                    echo "$eval_arch_diff_F1 $eval_arch_diff_NBPOINT_EXO_moy $eval_arch_diff_NBPOINT_TOTAL $eval_arch_diff_MR $eval_arch_diff_NBREG" >> .nb_point
                    ae_echo_ "=> For input parameter setting, program '$eval_arch_diff_F1' give $eval_arch_diff_MRI out of $eval_arch_diff_NBREG correct result(s)."
                else
                    ae_echo_ "=> For input parameter setting, program '$eval_arch_diff_F1' doesn't give  any correct result from $eval_arch_diff_NBREG expected."
                    echo "$eval_arch_diff_F1 0. $eval_arch_diff_NBPOINT_TOTAL 0. $eval_arch_diff_NBREG" >> .nb_point
                fi
            else
                ae_echo_ "$eval_arch_diff_F1 is not evaluated by $MYNAME. Check lab subject. If from subject it should you've got a configuration problem. Try to rebuild $MYNAME or contact teachers"
            fi
        done
        return 0
    fi
else
    msg_ 8 "No full or partial run !! Analyzing results is not possible"
    return 1
fi
}
############################################################################################################################
function disp_diff_arch_ ()
{
if [ -s .nb_diff ]
then
        msg_ 4 "Display difference from last evaluation of archive $EVALARCH"
        nb_ligne_ disp_diff_arch_ND .nb_diff
        for ((disp_diff_arch_i=1;disp_diff_arch_i<=$disp_diff_arch_ND;++disp_diff_arch_i))
        do
            disp_diff_arch_D=`sed -n $disp_diff_arch_i'p' .nb_diff`
            disp_diff_arch_VC=`echo $disp_diff_arch_D | cut -d' ' -f 1`
            disp_diff_arch_VS=`echo $disp_diff_arch_D | cut -d' ' -f 2`
            ae_echo_ `echo $disp_diff_arch_D| cut -d':' -f 2`" :"
            diff -b -w -a --old-line-format='yours    > '%L --new-line-format='solution > '%L $disp_diff_arch_VC $disp_diff_arch_VS |tee -a ${LOGFILE}
        done
fi
}
############################################################################################################################
# STUDENT LIB
############################################################################################################################
function first_choice_ ()
{
cat<<first_choice_EOF1 | tee -a ${LOGFILE}

////////////////////////////////////////////////////////
///   This is auto_eval version $VERSION for LAB $LABN $YEAR
////////////////////////////////////////////////////////
/// Current status
first_choice_EOF1

if [ -z "$EVALARCH" ]
then
    first_choice_EVALARCH="${TARFILE}_${GROUP_ID}.tar.gz"
else
    first_choice_EVALARCH="$EVALARCH"
fi
if [ -s ${CURDIR}/$first_choice_EVALARCH ]
then
    ae_echo_ "///  Archive file $first_choice_EVALARCH present"
    if [ -d $AUTODIR ]
    then
        ls -1 $AUTODIR/.unpack_ok >& /dev/null && ae_echo_ "///  Archive unpacked successfully"
        ls -1 $AUTODIR/.nb_compil >& /dev/null && ae_echo_ "///  "`cat $AUTODIR/.nb_compil`" out of $NBEXE programs compile successfully"
        ls -1 $AUTODIR/.nb_run >& /dev/null && ae_echo_ "///  "`cat $AUTODIR/.nb_run`" out of $NBEXE programs run successfully"
        ls -1 $AUTODIR/.nb_point >& /dev/null && ae_echo_ "///  "`cat $AUTODIR/.nb_point | awk 'BEGIN{c=0;s=0}{c+=$4;s+=$5;}END{printf("%.1f out of %.0f correct results where obtain",c,s);}'`
    fi
    if [ -d $AUTODIR -a -s ${AUTODIR}/.nb_diff ]
    then
        cat<<first_choice_EOF2 | tee -a ${LOGFILE}
////////////////////////////////////////////////////////

What do you want to do ?

    a) prepare an archive of your work.
    b) evaluate archive already generated.
    c) display differences from solution of last evaluated archive
    q) stop using this program

first_choice_EOF2
        read_an_answer_ first_choice_C a b c q;
    else
        cat<<first_choice_EOF3 | tee -a ${LOGFILE}
////////////////////////////////////////////////////////

What do you want to do ?

    a) prepare an archive of your work.
    b) evaluate archive already generated.
    q) stop using this program

first_choice_EOF3
        read_an_answer_ first_choice_C a b q;
    fi
else
    cat<<first_choice_EOF3 | tee -a ${LOGFILE}
///   No archive file $first_choice_EVALARCH present
////////////////////////////////////////////////////

What do you want to do ?

    a) prepare an archive of your work.
    q) stop using this program

first_choice_EOF3
    read_an_answer_ first_choice_C a q;
fi
}
############################################################################################################################
function choose_group_ ()
{
if [ -s $TMPDIR/gn ]
then
    eval $1=`cat $TMPDIR/gn`
else
    msg_ 4 "Setting your lab group"
    ae_echo_ "Please what is your group letter ?"
    read_an_answer_ choose_group_GL A B C D;
    ae_echo_ "Please what is your group number ?"
    read_an_answer_ choose_group_GN 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20;
    choose_group_GLN=`echo "${choose_group_GL}_${choose_group_GN}"`
    echo "$choose_group_GLN" > $TMPDIR/gn
    eval $1=$choose_group_GLN
fi
}
############################################################################################################################
function prb_arch_ ()
{
cat << prb_arch_EOF1 | tee -a ${LOGFILE}
===============================================================================
File $2 won't be archived
Sorry, $3 !
prb_arch_EOF1
if [ $# -gt 3 ]
then
cat << prb_arch_EOF2 | tee -a ${LOGFILE}
$4
===============================================================================
prb_arch_EOF2
fi
echo $(($1++))>>/dev/null;
}
############################################################################################################################
function gen_arch_ ()
{
gen_arch_TARFILE="${TARFILE}_${GROUP_ID}.tar"
if [ -s $gen_arch_TARFILE ]
then
    rm -f ./$gen_arch_TARFILE
fi
if [ -s ${gen_arch_TARFILE}.gz ]
then
    rm -f ./${gen_arch_TARFILE}.gz
fi
msg_ 4 "Archiving file for lab $LABN"
gen_arch_K=0
for gen_arch_f in `cat ${TMPDIR}/ffn`
do
    if [ -s ${gen_arch_f} -a -f ${gen_arch_f} -a -r ${gen_arch_f} ]
    then
        if [ -x ${gen_arch_f} ]
        then
            prb_arch_ gen_arch_K ${gen_arch_f} " your file is present, but it is an executable file" "Do a 'chmod 644 ${gen_arch_f}'"
        else
            tar rhf $gen_arch_TARFILE ./${gen_arch_f}
            if [ $? -eq 0 ]
            then
                ae_echo_ "File '${gen_arch_f}' correctly archived"
            else
                prb_arch_ gen_arch_K ${gen_arch_f} " your file is present, there is some problem to put it in an archive"
            fi
        fi
    else
        prb_arch_ gen_arch_K ${gen_arch_f} " your file is not present or not a regular file or not readable or of null size" "If it is not readable do a 'chmod 644 $gen_arch_f'"
    fi
done
if [ ${gen_arch_K} -gt 0 ]
then
    if [ -s $gen_arch_TARFILE ]
    then
        msg_ 1 "There is at least one missing file in your archive !"
    else
        msg_ 2 "Archive is empty or not generated ?" 
    fi
fi
if [ -s $gen_arch_TARFILE ]
then
   ae_echo_ "Compressing archive"
   gzip $gen_arch_TARFILE
   if [ $? -eq 0 ]
   then
       EVALARCH=${gen_arch_TARFILE}.gz
       msg_ 4 "Archive ${gen_arch_TARFILE}.gz ready to be auto evaluated or uploaded on the server."
    else
        ae_echo_  "Problem while compressing your archive !!! Check quota, $gen_arch_TARFILE and try again."
    fi
else
    if [ ${gen_arch_K} -eq 0 ]
    then
        msg_ 3 "Archive is empty or not generated but no file problem was identified ??"
    fi
fi
ae_echo_ -e "\n\n\n"
}
############################################################################################################################
#  CONFIG
############################################################################################################################
clear;
MYNAME=$0
echo "$MYNAME"
MYNAMESED=`echo "$MYNAME" | sed 's/\\//\\\\\\//g' | sed 's/\\./\\\\\\./g' `
CURDIR=`pwd`
TMPDIR=${CURDIR}/.auto_eval
AUTODIR=${CURDIR}/auto_eval_dir$$
clean_tmpdir_
mkdir $TMPDIR
trap "clean_tmpdir_;clean_autodir_;" 0
LABN=3
VERSION=0.5
YEAR=2018
TARFILE="./archive_lab3"
EVALARCH=''
cat<<FFN >$TMPDIR/ffn
company.cc
Poly.cc
Poly.h
FFN
cat<<FTS >$TMPDIR/fts
list_of_ex
list_of_ex_coef
company.h
test_company.cc
test_company.reg
test_company_00.dat
test_company_00.sol
test_poly_operators.cc
test_poly_operators.reg
test_poly_operators_00.dat
test_poly_operators_00.sol
test_poly_eucl_div.cc
test_poly_eucl_div.reg
test_poly_eucl_div_00.dat
test_poly_eucl_div_00.sol
Vector2.cc
Vector2.h
FTS
cat<<FTS1 >$TMPDIR/list_of_ex
test_company company
test_poly_operators Poly Vector2
test_poly_eucl_div Poly Vector2
FTS1
cat<<FTS2 >$TMPDIR/list_of_ex_coef
1
1
1
FTS2
cat<<FTS3 >$TMPDIR/company.h
#ifndef Company_lab3_H
#define Company_lab3_H

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// Base class of IT financial database |||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
/// employees class stores employees identification number (ID) and salary (salary)
class employees
{
    public:
        void setSalaryAndId(const int i, const double s);
        double getSalary(void) const;
        virtual void printEmployee(void) const;
    private:
        int ID;
        double salary;
};
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// First derived level : class correspond to general categories ||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
/// fixed-term contract category : employees only work in the company for a determined period. 
//! fixed_term class stores the period in months for which they are scheduled to stay in the company.
class fixed_term : public employees
{
    public:
        fixed_term(int id,double salary, double period_);
        double getPeriod(void) const;
        virtual double totalCost(void) const =0;
    private:
        double period;
};
/// Employees with a permanent contract. This category has a bonus corresponding to company
//! profits shared. permanent class represents this category and stores the bonus per month.
class permanent : public employees
{
    public:
        permanent(int id,double salary, double bonus_);
        virtual double cost(void) const =0;
    protected:
        double bonus;
};
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// second derived level : class corresponding to each type of permanent employees |
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
class manager : public permanent
{
    public:
        manager (int id, double salary, double bonus, double extra_bonus_, int team_size_);
        void printEmployee(void) const;
        double cost(void) const;
    private:
        int team_size;
        double extra_bonus;
};
class developer : public permanent
{
    public:
        developer (int id, double salary, double bonus, int number_of_active_project_);
        void printEmployee(void) const;
        double cost(void) const;
    private:
        int number_of_active_project;
};
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// second derived level : class corresponding to each type of fixed-term employees 
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
class trainee : public fixed_term
{
    public:
        trainee (int id, double salary, double period, double imputation_, const permanent &in_charge_ );
        void printEmployee(void) const;
        double totalCost(void) const;
    private:
        double imputation;
        const permanent &in_charge;
};
class subcontractor : public fixed_term
{
    public:
        subcontractor(int id, double salary, double period, double computer_cost_);
        void printEmployee(void) const;
        double totalCost(void) const;
    private:
        double computer_cost;
};
#endif
FTS3
cat<<FTS4 >$TMPDIR/test_company.cc
#include <iostream>
#include "company.h"
using namespace std;

int main()
{
    int ID,i,j;
    double s,b,d;
    // Generating  company employee
    cout<<"Enter id, salary, bonus, extra bonus and managed team size for Alice manager"<<endl; 
    cin>>ID>>s>>b>>d>>i;
    manager Alice(ID,s,b,d,i);
    cout<<"Enter id, salary, bonus, and active project in charge for Igor developer"<<endl; 
    cin>>ID>>s>>b>>i;
    developer Igor(ID,s,b,i);
    cout<<"Enter id, salary, bonus, and active project in charge for Kim developer"<<endl; 
    cin>>ID>>s>>b>>i;
    developer Kim(ID,s,b,i);
    cout<<"Enter id, salary, bonus, and active project in charge for Aalap developer"<<endl; 
    cin>>ID>>s>>b>>i;
    developer Aalap(ID,s,b,i);
    cout<<"Enter id, salary, contract period, and charge for Ling subcontractor"<<endl; 
    cin>>ID>>s>>b>>d;
    subcontractor Ling(ID,s,b,d);
    cout<<"Enter id, salary, contract period, and imputation ration for John student"<<endl; 
    cin>>ID>>s>>b>>d;
    trainee John(ID,s,b,d,Igor);
    // some testing variable
    //employees e;
    //e.setSalaryAndId(900,0.);
    //permanent Olivia(900,2500.,300.);
    //fixed_term Rabier(900,2500.,2.);

    // some pointers
    employees *pe;
    permanent *pp;
    fixed_term *pf;
    manager *pm;
    developer *pd;
    subcontractor *ps;
    trainee *pt;

    //
    cout<<"OUT01 :";Alice.printEmployee();
    cout<<"OUT02 :";Igor.printEmployee();
    cout<<"OUT03 :";Kim.printEmployee();
    cout<<"OUT04 :";Aalap.printEmployee();
    cout<<"OUT05 :";Ling.printEmployee();
    cout<<"OUT06 :";John.printEmployee();


    //pe=&Alice;
    //cout<<"OUT07 :";pe->printEmployee();
    //cout<<"OUT08 :"<<pe->cost()<<endl;;
    //cout<<"OUT09 :"<<pe->totalCost()<<endl;
    pe=NULL;

    //pe=&Igor;
    //cout<<"OUT10 :";pe->printEmployee();
    //cout<<"OUT11 :"<<pe->cost()<<endl;
    //cout<<"OUT12 :"<<pe->totalCost()<<endl;
    pe=NULL;

    //pe=&Ling;
    //cout<<"OUT13 :";pe->printEmployee();
    //cout<<"OUT14 :"<<pe->cost()<<endl;
    //cout<<"OUT15 :"<<pe->totalCost()<<endl;
    pe=NULL;

    //pe=&John;
    //cout<<"OUT16 :";pe->printEmployee();
    //cout<<"OUT17 :"<<pe->cost()<<endl;
    //cout<<"OUT18 :"<<pe->totalCost()<<endl;
    pe=NULL;

    //
    //pp=&Alice;
    //cout<<"OUT19 :";pp->printEmployee();
    //cout<<"OUT20 :"<<pp->cost()<<endl;
    //cout<<"OUT21 :"<<pp->totalCost()<<endl;
    pp=NULL;

    //pp=&Igor;
    //cout<<"OUT22 :";pp->printEmployee();
    //cout<<"OUT23 :"<<pp->cost()<<endl;
    //cout<<"OUT24 :"<<pp->totalCost()<<endl;
    pp=NULL;

    //pp=&Ling;
    //cout<<"OUT25 :";pp->printEmployee();
    //cout<<"OUT26 :"<<pp->cost()<<endl;
    //cout<<"OUT27 :"<<pp->totalCost()<<endl;
    pp=NULL;

    //pp=&John;
    //cout<<"OUT28 :";pp->printEmployee();
    //cout<<"OUT29 :"<<pp->cost()<<endl;
    //cout<<"OUT30 :"<<pp->totalCost()<<endl;
    pp=NULL;
    
    //
    //pf=&Alice;
    //cout<<"OUT31 :";pf->printEmployee();
    //cout<<"OUT32 :"<<pf->cost()<<endl;
    //cout<<"OUT33 :"<<pf->totalCost()<<endl;
    pf=NULL;

    //pf=&Igor;
    //cout<<"OUT34 :";pf->printEmployee();
    //cout<<"OUT35 :"<<pf->cost()<<endl;
    //cout<<"OUT36 :"<<pf->totalCost()<<endl;
    pf=NULL;

    //pf=&Ling;
    //cout<<"OUT37 :";pf->printEmployee();
    //cout<<"OUT38 :"<<pf->cost()<<endl;
    //cout<<"OUT39 :"<<pf->totalCost()<<endl;
    pf=NULL;

    //pf=&John;
    //cout<<"OUT40 :";pf->printEmployee();
    //cout<<"OUT41 :"<<pf->cost()<<endl;
    //cout<<"OUT42 :"<<pf->totalCost()<<endl;
    pf=NULL;

    //
    //pm=&Alice;
    //cout<<"OUT43 :";pm->printEmployee();
    //cout<<"OUT44 :"<<pm->cost()<<endl;
    //cout<<"OUT45 :"<<pm->totalCost()<<endl;
    pm=NULL;

    //pm=&Igor;
    //cout<<"OUT46 :";pm->printEmployee();
    //cout<<"OUT47 :"<<pm->cost()<<endl;
    //cout<<"OUT48 :"<<pm->totalCost()<<endl;
    pm=NULL;

    //pm=&Ling;
    //cout<<"OUT49 :";pm->printEmployee();
    //cout<<"OUT50 :"<<pm->cost()<<endl;
    //cout<<"OUT51 :"<<pm->totalCost()<<endl;
    pm=NULL;

    //pm=&John;
    //cout<<"OUT51 :";pm->printEmployee();
    //cout<<"OUT52 :"<<pm->cost()<<endl;
    //cout<<"OUT53 :"<<pm->totalCost()<<endl;
    pm=NULL;

    //
    //pd=&Alice;
    //cout<<"OUT54 :";pd->printEmployee();
    //cout<<"OUT55 :"<<pd->cost()<<endl;
    //cout<<"OUT56 :"<<pd->totalCost()<<endl;
    pd=NULL;

    //pd=&Igor;
    //cout<<"OUT57 :";pd->printEmployee();
    //cout<<"OUT58 :"<<pd->cost()<<endl;
    //cout<<"OUT59 :"<<pd->totalCost()<<endl;
    pd=NULL;

    //pd=&Ling;
    //cout<<"OUT60 :";pd->printEmployee();
    //cout<<"OUT61 :"<<pd->cost()<<endl;
    //cout<<"OUT62 :"<<pd->totalCost()<<endl;
    pd=NULL;

    //pd=&John;
    //cout<<"OUT63 :";pd->printEmployee();
    //cout<<"OUT64 :"<<pd->cost()<<endl;
    //cout<<"OUT65 :"<<pd->totalCost()<<endl;
    pd=NULL;

    //
    //ps=&Alice;
    //cout<<"OUT66 :";ps->printEmployee();
    //cout<<"OUT67 :"<<ps->cost()<<endl;
    //cout<<"OUT68 :"<<ps->totalCost()<<endl;
    ps=NULL;

    //ps=&Igor;
    //cout<<"OUT69 :";ps->printEmployee();
    //cout<<"OUT70 :"<<ps->cost()<<endl;
    //cout<<"OUT71 :"<<ps->totalCost()<<endl;
    ps=NULL;

    //ps=&Ling;
    //cout<<"OUT72 :";ps->printEmployee();
    //cout<<"OUT73 :"<<ps->cost()<<endl;
    //cout<<"OUT74 :"<<ps->totalCost()<<endl;
    ps=NULL;

    //ps=&John;
    //cout<<"OUT75 :";ps->printEmployee();
    //cout<<"OUT76 :"<<ps->cost()<<endl;
    //cout<<"OUT77 :"<<ps->totalCost()<<endl;
    ps=NULL;

    //
    //pt=&Alice;
    //cout<<"OUT78 :";pt->printEmployee();
    //cout<<"OUT79 :"<<pt->cost()<<endl;
    //cout<<"OUT80 :"<<pt->totalCost()<<endl;
    pt=NULL;

    //pt=&Igor;
    //cout<<"OUT81 :";pt->printEmployee();
    //cout<<"OUT82 :"<<pt->cost()<<endl;
    //cout<<"OUT83 :"<<pt->totalCost()<<endl;
    pt=NULL;

    //pt=&Ling;
    //cout<<"OUT84 :";pt->printEmployee();
    //cout<<"OUT85 :"<<pt->cost()<<endl;
    //cout<<"OUT86 :"<<pt->totalCost()<<endl;
    pt=NULL;

    //pt=&John;
    //cout<<"OUT87 :";pt->printEmployee();
    //cout<<"OUT88 :"<<pt->cost()<<endl;
    //cout<<"OUT89 :"<<pt->totalCost()<<endl;
    pt=NULL;

    //cout<<"OUT90 :";e.printEmployee();
    cout<<endl;
    cout<<endl;
    cout<<endl;
    cout<<endl;
    cout<<"finished"<<endl;

    return 0;
}
FTS4
cat<<FTS5 >$TMPDIR/test_company.reg
OUT01:T:1
OUT02:T:1
OUT03:T:1
OUT04:T:1
OUT05:T:1
OUT06:T:1
FTS5
cat<<FTS6 >$TMPDIR/test_company_00.dat
2 5000.  400.  50.  7
1 3000.  500.  3
8 2500.  100.  1
3 2700.  200.  2
100 2000.  6.  23.
200 1800.  3.  0.1
FTS6
cat<<FTS7 >$TMPDIR/test_company_00.sol
ID 2, Salary 5000, Bonus 400, Extra bonus 50, Team size 7
ID 1, Salary 3000, Bonus 500, Project number 3
ID 8, Salary 2500, Bonus 100, Project number 1
ID 3, Salary 2700, Bonus 200, Project number 2
ID 100, Salary 2000, Period 6, Computer cost 23
ID 200, Salary 1800, Period 3, Imputation 0.1
FTS7
cat<<FTS8 >$TMPDIR/test_poly_operators.cc
#include <iostream>
#include "Poly.h"
using namespace std;

int main()
{
    // Some coefficients to instanciate Poly object
    // Warning : in this program, we suppose that the maximum order of a polynomial is 9
    // (maximum number of coefficient : 10)
    double coef1[10]={0};
    double coef2[10]={0};
    double coef3[10]={0};
    
    // Instanciate 3 objects
    
    int n ; // Polynomial order
    
    // Instanciate p1 :
    cout << "Input order of p1 : n = ";
    cin >> n ;
    
	cout << "Input coeffient of p1 (from order 0 to order n) :" << endl ; 
    for(int i = 0; i<=n ; i++){
    	cin >> coef1[i] ;
    }
    Poly p1(coef1,n);
    
    // Instanciate p2 :
    cout << "Input order of p2 : n = ";
    cin >> n ;
    
	cout << "Input coeffient of p2 (from order 0 to order n) :" << endl ; 
    for(int i = 0; i<=n ; i++){
    	cin >> coef2[i] ;
    }
    Poly p2(coef2,n);
    
    // Instanciate p3 :
    cout << "Input order of p3 : n = ";
    cin >> n ;
    
	cout << "Input coeffient of p3 (from order 0 to order n) :" << endl ; 
    for(int i = 0; i<=n ; i++){
    	cin >> coef3[i] ;
    }
    Poly p3(coef3,n);
    
    // test output and constructor correct assignement of values
    cout << "Testing constructor and output " << endl ;
    cout<<"p1 : ";
    p1.print();
    cout<<"p2 : ";
    p2.print();
    cout<<"p3 : ";
    p3.print();

    // test addition operator. Use of default copy constructor to avoid use of forbiden assignement operator with 
    // already existing instance of Poly
    cout << "Testing addition " << endl ;
    Poly padd(p2+p3);
    cout<<"p2+p3 : ";
    padd.print();
    Poly padd2(p3+p2);
    cout<<"p3+p2 : ";
    padd2.print();

    // test substraction operator.
    cout << "Testing substraction " << endl ; 
    cout<<"p2-p3 : ";
    Poly pneg(p2-p3);
    pneg.print();
    cout<<"p3-p2 : ";
    Poly pneg2(p3-p2);
    pneg2.print();
    // check that operators (here -) are returning correct instance (i.e coeficient of higher order is not null)
    cout<<"p3-p3=0 : ";
    // Illustration here of the implicite use of the copy constructor when left hand side of 
    // the assignement operator is not already created. Otherwise this would have give a runtime error (throw)
    // as = operator is throwing exception.
    Poly pneg3=p3-p3;
    pneg3.print();

    // test multiplication operator. 
    cout << "Testing multiplication " << endl ;
    cout<<"p2*p3 : ";
    Poly pprod=(p2*p3);
    pprod.print();
    cout<<"p3*p2 : ";
    Poly pprod2=(p3*p2);
    pprod2.print();

    // test "complicate"  operation
    cout << "Testing complicate operation " << endl ;
    cout<<"p3-p1*p2 : ";
    Poly pcplx(p3-p1*p2);
    pcplx.print();
    cout<<"(p3-p1*p2)*p1 : ";
    Poly pcplx2((p3-p1*p2)*p1);
    pcplx2.print();

    // test () operator
    double x;
    cout << "Testing () operator " << endl ;
    cout<<"First try, input a value for x1 : " << endl ;
    cin >> x ;
    cout << "p2(x1) : "<<p2(x) <<endl ;
    cout << "p3(x1) : "<<p3(x) <<endl ;

    cout<<"Second try, input a value for x2 : " << endl ;
    cin >> x ;
    cout << "p2(x2) : "<<p2(x) <<endl ;
    cout << "p3(x2) : "<<p3(x) <<endl ;

    // test exception for problematic cases
    cout << "Testing exceptions from problematic cases " << endl ; 
    try
    {
        Poly pb(coef3,n+1);
    }
    catch (int e)
    {
         cout << "Error1 : catching exception for null order coef "<<endl;
    }
    
    try
    {    	
        pcplx=pcplx2;
    }
    catch (int e)
    {
         cout << "Error2 : catching exception for = usage"<<endl;
    }

    return 0;
}

FTS8
cat<<FTS9 >$TMPDIR/test_poly_operators.reg
p1:T:1/3
p2:T:1/3
p3:T:1/3
p2+p3:T:1/2
p3+p2:T:1/2
p2-p3:T:1/3
p3-p2:T:1/3
p3-p3=0:T:1/3
p2\\*p3:T:1/2
p3\\*p2:T:1/2
p3-p1\\*p2:T:1/2
(p3-p1\\*p2)\\*p1:T:1/2
p2(x1):R:1/4
p3(x1):R:1/4
p2(x2):R:1/4
p3(x2):R:1/4
Error1:T:1
Error2:T:1
FTS9
cat<<FTS10 >$TMPDIR/test_poly_operators_00.dat
2
0
0
0.5
3
1
0
4
2
5
8
6
0
0
2
1
1.5
1
FTS10
cat<<FTS11 >$TMPDIR/test_poly_operators_00.sol
poly(x)=  +0.5*x^2
poly(x)= 1 +4*x^2 +2*x^3
poly(x)= 8 +6*x^1 +2*x^4 +1*x^5
poly(x)= 9 +6*x^1 +4*x^2 +2*x^3 +2*x^4 +1*x^5
poly(x)= 9 +6*x^1 +4*x^2 +2*x^3 +2*x^4 +1*x^5
poly(x)= -7 -6*x^1 +4*x^2 +2*x^3 -2*x^4 -1*x^5
poly(x)= 7 +6*x^1 -4*x^2 -2*x^3 +2*x^4 +1*x^5
poly(x)= 0
poly(x)= 8 +6*x^1 +32*x^2 +40*x^3 +14*x^4 +1*x^5 +8*x^6 +8*x^7 +2*x^8
poly(x)= 8 +6*x^1 +32*x^2 +40*x^3 +14*x^4 +1*x^5 +8*x^6 +8*x^7 +2*x^8
poly(x)= 8 +6*x^1 -0.5*x^2
poly(x)=  +4*x^2 +3*x^3 -0.25*x^4
16.75
34.7188
7
17
catching exception for null order coef
catching exception for = usage
FTS11
cat<<FTS12 >$TMPDIR/test_poly_eucl_div.cc
#include <iostream>
#include "Poly.h"
using namespace std;

int main()
{
    // Some coefficients to instanciate Poly object
    // Warning : in this program, we suppose that the maximum order of a polynomial is 9
    // (maximum number of coefficient : 10)
    double coef1[10]={0};
    double coef2[10]={0};
    
    // Instanciate 2 objects
    
    int n ; // Polynomial order
    
    // Instanciate p1 :
    cout << "Input order of p1 : n = ";
    cin >> n ;
    
	cout << "Input coeffient of p1 (from order 0 to order n) :" << endl ; 
    for(int i = 0; i<=n ; i++){
    	cin >> coef1[i] ;
    }
    Poly p1(coef1,n);
    
    // Instanciate p2 :
    cout << "Input order of p2 : n = ";
    cin >> n ;
    
	cout << "Input coeffient of p2 (from order 0 to order n) :" << endl ; 
    for(int i = 0; i<=n ; i++){
    	cin >> coef2[i] ;
    }
    Poly p2(coef2,n);

    // test division operator  : QUOTIENT part.
    cout << "Testing euclidian divison, quotient part " << endl ;
    Poly pprod=(p1*p2);
    Poly pdivQ(pprod.euclidienDivisionQ(p1));
    cout<<"Q=(p2*p1)/p1=p2 : ";
    pdivQ.print();
    Poly pdivQ2(p2.euclidienDivisionQ(p1));
    cout<<"Q=p2/p1 : ";
    pdivQ2.print();

    // test division operator  : RESIDUAL part.
    cout << "Testing euclidian divison, residual part " << endl ;
    Poly pdivR(pprod.euclidienDivisionR(p1,pdivQ));
    cout<<"R=(p2*p1)-Q((p2*p1)/p1)*p1=0 : ";
    pdivR.print();
    Poly pdivRd(pprod.euclidienDivisionR(p1));
    cout<<"Rdirect=(p2*p1)-Q((p2*p1)/p1)*p1=0 : ";
    pdivRd.print();
    Poly pdivR2(p2.euclidienDivisionR(p1,pdivQ2));
    cout<<"R=p2-Q(p2/p1)*p1 : ";
    pdivR2.print();
    Poly pdivR2d(p2.euclidienDivisionR(p1));
    cout<<"Rdirect=p2-Q(p2/p1)*p1 : ";
    pdivR2d.print();

    return 0;
}

FTS12
cat<<FTS13 >$TMPDIR/test_poly_eucl_div.reg
Q=(p2\\*p1)/p1=p2:T:1
Q=p2/p1:T:1
R=(p2\\*p1)-Q((p2\\*p1)/p1)\\*p1=0:T:1/4
Rdirect=(p2\\*p1)-Q((p2\\*p1)/p1)\\*p1=0:T:1/4
R=p2-Q(p2/p1)\\*p1:T:1/4
Rdirect=p2-Q(p2/p1)\\*p1:T:1/4
FTS13
cat<<FTS14 >$TMPDIR/test_poly_eucl_div_00.dat
3
1
0
4
2
5
8
6
0
0
2
1
FTS14
cat<<FTS15 >$TMPDIR/test_poly_eucl_div_00.sol
poly(x)= 8 +6*x^1 +2*x^4 +1*x^5
poly(x)=  +0.5*x^2
poly(x)= 0
poly(x)= 0
poly(x)= 8 +6*x^1 -0.5*x^2
poly(x)= 8 +6*x^1 -0.5*x^2
FTS15
cat<<FTS16 >$TMPDIR/Vector2.cc
#include "Vector2.h"
#include <cstring>
#include <new>
#include <cmath>

using namespace std;

Vector::Vector(const int & size_)
    : size(size_),values(NULL)
{

    // Here observe that if size<1 the second test is not done. It preserve trying allocating with
    // a 0 or negative value.
    if (size < 1 || !( values = new (nothrow) double[size] ))
    {
        cout<<"Error in Vector constructor : size is inappropriate"<<endl;
        if (size < 1) cout<<"Size parameter should be greater than 0"<<endl;
        else cout<<"Size is to big. Memory exhausted"<<endl;
        throw -size;
    }

}
Vector::Vector(const Vector & input)
    : size(input.size),values(NULL)
{
    if ( !( values = new (nothrow) double[size] ) )
    {
        cout<<"In copy constructor memory is exhausted"<<endl;
        throw -size;
    }
    // memcpy : This is a way to copy information stored at a specific address in memory to an other address.
    // This information can be a double a int or what so ever. But it also can be a set of double like here.
    // See man page for further information
    memcpy((void *) values,(void *) input.values,sizeof( double )*size);
}
Vector::~Vector()
{
    // why a test as constructor are checking things? Because we throw a exception when there is problem in constructor
    // so we don't know if this exception will not be cached. If yes program may continue with unallocated memory for this
    // instance. And as soon as the program jump out of the context where this instance have been created it will call
    // this method and delete should not be done as nothing was allocated. By testing if values is not null we prevent
    // bug.
    // This also explain why in constructor the first thing which is done is to set values to NULL.
    if (values) delete [] values;
    values = NULL;
}
Vector & Vector::operator=(const Vector & v)
{
    const int min_size = ( size > v.size ) ? v.size : size;
    memcpy((void *) values,(void *) v.values,sizeof( double )*min_size);
    // for debuging purpose only
    if (size != v.size)
        cout<<"warning: = operator on vector of different size ! Smallest part treated"<<endl;
    return *this;
}
double Vector::operator()(const int & i) const
{
    if ( i > -1 && i < size )
        return values[i];
    else
    {
        cout<<"error: incorrect index ! "<<i<<endl;
        throw -3;
    }
}
double & Vector::operator()(const int & i)
{
    if ( i > -1 && i < size )
        return values[i];
    else
    {
        cout<<"error: incorrect index ! "<<i<<endl;
        throw -4;
    }
}
Vector & Vector::operator*=(const double & a)
{
    for (int i = 0; i < size; ++i) values[i] *= a;
    return *this;
}
Vector & Vector::operator+=(const Vector & v)
{
    const int min_size = ( size > v.size ) ? v.size : size;
    for (int i = 0; i < min_size; ++i) values[i] += v.values[i];
    return *this;
}
Vector & Vector::operator-=(const Vector & v)
{
    const int min_size = ( size > v.size ) ? v.size : size;
    for (int i = 0; i < min_size; ++i) values[i] -= v.values[i];
    return *this;
}
Vector Vector::operator*(const double & a) const
{
    // without use of *= operator ; see below for alternative
    Vector v(size);
    for (int i = 0; i < size; ++i) v.values[i] = values[i]*a;
    return v;
}
Vector Vector::operator+(const Vector & v) const
{
    // this implementation use the += operator. From a performance point of view some may
    // say that using the copy constructor add the work of copying values of left hand side terms in
    // newly created memory. If we had put a full implementation here it would have been direct. In
    // a new vector we set by a loop directly the resulting sum.
    // Well it's true but the memcpy is rather efficient and the data are certainly mostly in the cache afterward.
    //
    // But the interesting aspect of this design is that you implement only once the for loop (in the += operator)
    // and this is the important fact. Only one implementation of the same thing avoid buggs.
    // Imagine that operator where more complicated, let say 20 lines of codes. Use of this technique (when possible)
    // avoid writing 40 lines of codes. And if bug have to be corrected you only need to correct one piece of code not
    // two.
    //
    Vector res_vect(*this);
    res_vect += v;
    return res_vect;
}
Vector Vector::operator-(const Vector & v) const
{
    Vector res_vect(*this);
    res_vect -= v;
    return res_vect;
}
double Vector::operator*(const Vector & v) const
{
    double res = 0.;
    if ( v.size != size )
    {
        cout<<"error:  for * operator vector must be of the same size !"<<endl;
        throw -5;
    }
    else
    {
        for (int i = 0; i < size; ++i) res += values[i]*v.values[i];
    }
    return res;
}
double Vector::norm(void) const
{
    // Again here we use * operator implemented above to avoid duplication
    // if we decide to us blas or manual unrolled loop to improve
    // performance of * operator, this norm operator will have also the
    // benefit of any improvement.
    double res = ( *this )*( *this );
    return sqrt(res);
}

int Vector::getSize(void) const
{
    return size;
}
std::ostream & operator << (std::ostream & ofs, const Vector & v)
{
    int i,size = v.size;
    if (size)
    {
        ofs << "[";
        ofs << v.values[0];
        for (i = 1; i < size; ++i)
        {
            ofs<<", "<< v.values[i];
        }
        ofs << "]";
    }
    else
        ofs <<endl<<" Empty vector ";
    return ofs;
}
FTS16
cat<<FTS17 >$TMPDIR/Vector2.h
#ifndef Vector_lab_H
#define Vector_lab_H
#include <iostream>

// Class Vector is defining a new type of object that deal with multidimensional Vector.
// Each instance of this class have it's own dimension and set of double values.
//
class Vector
{
    public:
        // Constructor member
        // Instantiate a Vector object using size argument to define the dimension of the vector
        // (i.e. the number of values this object will treat)
        // The object generated don't have values set after construction. They are undefined.
        // Incorrect size will make this method throwing an exception.
        // By incorrect we mean size<1 or size so big that you exhaust computer memory.
        Vector(const int & size);

        // Constructor member
        // Instantiate a Vector object by using a other instance (copy constructor)
        // New instance will have the same dimension and values as input parameter
        Vector(const Vector &input);

        // Destructor
        ~Vector();

        // operator member
        // equal operator
        // input : instance invoking this method (left hand side of the operator) called below u
        //         instance given as argument (right hand side of the operator) called below v
        // output : a reference to u containing for the first common index the value of v.
        // By "first common index" we are talking of index starting at 0 up to the minimum of dimension v and
        // dimension u.
        Vector & operator=(const Vector & v);

        // operator member
        // give the ith value of a instance without changing this instance.
        // It's invocation is  in a const context (const instance or const method)
        // input : instance invoking this method (left hand side of the operator) called below u
        //         query index i given in parentheses
        // output : double corresponding to index i of u
        double operator()(const int &i) const;

        // operator member
        // give the reference to the ith value of a instance
        // input : instance invoking this method (left hand side of the operator) called below u
        //         query index i given in parentheses
        // output : reference to double corresponding to index i of u
        double &operator()(const int &i);

        // operator member
        // scaling of a vector
        // input : instance invoking this method (left hand side of the operator) called below u
        //         scaling value a
        // output : a reference to u containing the product of u(i) by a, i in {0,...size-1}.
        Vector &operator*=(const double & a);

        // operator member
        // addition of a vector to an other
        // input : instance invoking this method (left hand side of the operator) called below u
        //         instance given as argument (right hand side of the operator) called below v
        // output : a reference to u containing for the first common index the sum of u and v.
        // By "first common index" we are talking of index starting at 0 up to the minimum of dimension v and
        // dimension u.
        Vector &operator+=(const Vector & v);

        // operator member
        // subtraction of a vector to an other
        // same as += except that arithmetic operation is subtraction.
        Vector &operator-=(const Vector & v);

        // operator member
        // Result of the multiplication of a vector by value.
        // input : instance invoking this method (left hand side of the operator) called below u
        //         scaling value a
        // output : a new instance of the class Vector containing u scaled by a.
        Vector operator*(const double & a) const;

        // operator member
        // addition of 2 vectors.
        // input : instance invoking this method (left hand side of the operator) called below u
        //         instance given as argument (right hand side of the operator) called below v
        // output : a new instance of the class Vector,initiated as a copy of u, and
        // containing the sum of first common index of u and v.
        // By "first common index" we are talking of index starting at 0 up to the minimum of dimension v and
        // dimension u.
        Vector operator + (const Vector & v) const;

        // operator member
        // subtraction of 2 vectors.
        // input : instance invoking this method (left hand side of the operator) called below u
        //         instance given as argument (right hand side of the operator) called below v
        // output : a new instance of the class Vector,initiated as a copy of u, and
        // containing the difference of first common index of u and v.
        // By "first common index" we are talking of index starting at 0 up to the minimum of dimension v and
        // dimension u.
        Vector operator - (const Vector & v) const;

        // operator member
        // dot product of 2 vector.
        // input : instance invoking this method (left hand side of the operator) called below u
        //         instance given as argument (right hand side of the operator) called below v
        // output : a double corresponding to the dot product
        // if you declare
        // double x=u*v;
        // then
        // x=Sum(u(i)*v(i))
        //    i in {0,...size-1}
        // If u and v don't have the same size, a exception is throw as it is not considered to be possible here.
        // This operator is returning a double corresponding to the dot product
        double operator * (const Vector & v) const;

        // computing member
        // Euclidean norm of the vector.
        // No argument used as it apply on instance which call this method
        // This member function is returning a double corresponding to the norm of the vector
        double norm(void) const;

        // access member
        //  give the dimension of the instance of the vector
        int getSize(void) const;


        // friend function to the class
        // to simplify output overloading of << operator of the class ostream to output instance of Vector class.
        friend std::ostream & operator << (std::ostream &, const Vector &);

    private:
        int size;
        double *values;
};

#endif
FTS17
EPSILON_RES=1.e-10
if [ !  -s $TMPDIR/list_of_ex  ]
then
    msg_ 3 "Configuration problem : $TMPDIR/list_of_ex not present. Rebuild $MYNAME"
    exit 1
fi
NBEXE=`cat $TMPDIR/list_of_ex | wc -l| cut -d' ' -f1`
if [ ! -s $TMPDIR/list_of_ex_coef  ]
then
    msg_ 3 "Configuration problem : $TMPDIR/list_of_ex_coef not present. Rebuild $MYNAME"
    exit 1
fi
SUMCOEF=`cat $TMPDIR/list_of_ex_coef | awk 'BEGIN{s=0.;}{s+=\$1}END{print s}'`
LOGFILE=/dev/null
LOGYN=0
while [ $# -gt 0 ]
do
    case $1 in
        -h)
            echo "Usage :"
            echo -e "\n  "`basename $MYNAME`" [OPTION]\n"
            echo "With OPTION from following :"
            echo -e "\t-h : This message."
            echo -e "\t-l : Log you session (what you see on the screen and your answers) in a file."
            echo "";
            exit 0;;
        -l)
            LOGYN=1;
            LOGFILE=${CURDIR}/$$_auto_eval.log
            echo -e "Your session will be logged in "`basename $LOGFILE`"\n";;
        -x)
            set -x;;
    esac
    shift;
done
############################################################################################################################
#  PRG
############################################################################################################################
choose_group_ GROUP_ID
while [ "$first_choice_C" != "q" ]
do
    first_choice_
    case $first_choice_C in
        a)
            gen_arch_;;
        b)
            for eval_arch_ in eval_arch_check_ eval_arch_genrep_ eval_arch_unpack_ eval_arch_compil_ eval_arch_run_ eval_arch_diff_
            do
                eval $eval_arch_;
                if [ $? -ne 0 ]
                then
                    break;
                fi
            done
            cd $CURDIR;;
        c)
            cd $AUTODIR;
            disp_diff_arch_;
            cd $CURDIR;;
    esac
done
