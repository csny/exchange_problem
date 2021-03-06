//
//  main.m
//  exchange_problem
//
//  Created by macbook on 2014/08/04.
//  Copyright (c) 2014年 macbook. All rights reserved.
//

#import <Foundation/Foundation.h>


const int kind = 6; // 硬貨の種類の数
int coinvalue[kind] = {1,2,4,8,16,32}; // 硬貨の種類
const int imax = 63; // 探索最深度
int remaindermemo[imax]; // 支払い残額のメモ、再帰してforで使い回すので配列化
int dp[imax]; // 使った硬貨の組み合わせ記録、上書き上等
int dpanswer[imax]; // 使った硬貨の組み合わせの答え記録用
int minnum=0; // 硬貨の最低使用枚数
int hit=0; // 残額が丁度0になった組み合わせの数


// 使った硬貨の組み合わせをコピー
void cpdp(int k){
    for (int i=0;i<k;i++){
        dpanswer[i] = dp[i];
    }
}

// 残額63から硬貨の種類毎に引いてみる深さ優先探索
void payment(int i,int remainder){
    
    if (i > imax){return;} // 1x63が最大枚数なので、終了条件
    remaindermemo[i]=remainder;
    //NSLog(@"payrest:%d,i:%d",restmemo[i],i);
    
    
    if (remaindermemo[i] > 0){
        for (int j = kind-1; j >= 0; j--){  // 硬貨の額の大きい方から試行
            if(i==0 | coinvalue[j]<=dp[i-1]){ // 順列ではなく組み合わせにしたいので、前回より大きい硬貨は選ばない
                dp[i] = coinvalue[j];
                payment(i+1, remaindermemo[i] -= coinvalue[j]); // 残額から硬貨の額を引いて再帰呼出、深さ優先
                remaindermemo[i] += coinvalue[j]; // 呼出で残額から引いた硬貨の額を復元
            }
        }
    } else if (remaindermemo[i] == 0){
        hit++;
        if(minnum == 0 | minnum > i){
            minnum = i;
            cpdp(i); // 答えの組み合わせをメモ
        }
    }
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // iの初期値と残額を渡して探索開始
        payment(0,63);
        
        // 出力
        NSLog(@"HIT数%d",hit);
        NSLog(@"最小支払い枚数は%d",minnum);
        for (int i=0;i<minnum;i++){
            NSLog(@"使った硬貨 %d",dpanswer[i]);
        }
        
    }
    return 0;
}

