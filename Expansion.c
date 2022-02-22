// #include "swan/swan.h"

// bool THUMB_BRANCH_DecryptValidateBoxPkmBlock(BoxPkm *pPkm) {
//   bool v2 = 1;
//   if (!(pPkm->pad & 2)) {
//     cryptData(&pPkm->species, 128, pPkm->checksum);
//     if (generatePkmChecksum(&pPkm->species, 128) != pPkm->checksum) {
//       v2 = 0;
//     }
//   }
//   return v2;
// }

// char *THUMB_BRANCH_loadPersonalPokeRegionalDexIndices(s16 blkGroupID, u32 *countOfRegionDexPokes) {
//   int fileLength;
//   s16 v3 = 0;
//   char *buf = GFL_ArcToolReadHeapNewLZGetLen((ArcTool *)0x2141428, 0x2C5, 0, blkGroupID, &fileLength);
//   u32 v5 = (fileLength << 15) >> 16;
//   if (countOfRegionDexPokes) {
//     for (u32 i = 0; i < v5; i++) {
//       if (buf[i] != 999) {
//         v3++;
//       }
//     }
//     *countOfRegionDexPokes = v3;
//   }
//   return buf;
// }
