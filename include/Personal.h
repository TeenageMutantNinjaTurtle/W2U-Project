#ifndef __PERSONAL_H
#define __PERSONAL_H

#include "Types.h"

typedef struct PersonalData {
  u8 BaseHP;
  u8 BaseATK;
  u8 BaseDEF;
  u8 BaseSPE;
  u8 BaseSPA;
  u8 BaseSPD;
  u8 Type1;
  u8 Type2;
  u8 CaptureRate;
  u8 EvoStage;
  u16 EVYield;
  u16 WildItem50;
  u16 WildItem5;
  u16 WildItem1;
  u8 GenderProb;
  u8 EggHappiness;
  u8 BaseHappiness;
  u8 ExpGroup;
  u8 EggGroup1;
  u8 EggGroup2;
  u8 Abil1;
  u8 Abil2;
  u8 AbilHidden;
  u8 EscapeRate;
  u16 FormeDataOffs;
  u16 FormeSpriteOffs;
  u8 FormeCount;
  u8 Color;
  u16 BaseEXP;
  u16 HeightCm;
  u16 WeightCg;
  s32 TMHM1;
  s32 TMHM2;
  s32 TMHM3;
  s32 TMHM4;
  s32 TypeTutors;
  s32 SpecialTutors[4];
} PERSONAL_DATA;

#endif