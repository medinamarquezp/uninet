"use strict";
const { Contract } = require("fabric-contract-api");

class RegisterStudents extends Contract {
  async initLedger(ctx) {
    const assets = [
      {
        id: "1689534842352",
        name: "Makenna",
        surname: "Zieme",
        email: "felton_stehr@yahoo.com",
        birthdate: "1987-04-08T02:40:41.081Z",
        registered: "2022-11-08T14:19:37.969Z",
        degree: "history",
      },
      {
        id: "1689534842353",
        name: "Alford",
        surname: "Macejkovic",
        email: "alda90@gmail.com",
        birthdate: "1994-10-05T04:06:29.857Z",
        registered: "2022-11-09T03:14:06.511Z",
        degree: "physics",
      },
      {
        id: "1689534842354",
        name: "Josephine",
        surname: "Fadel",
        email: "ward43@yahoo.com",
        birthdate: "1947-12-15T05:27:15.063Z",
        registered: "2023-05-16T01:29:49.579Z",
        degree: "computer-science",
      },
      {
        id: "1689534842355",
        name: "Abbie",
        surname: "Kunze",
        email: "rachelle63@yahoo.com",
        birthdate: "2004-12-26T07:57:29.179Z",
        registered: "2023-04-22T02:30:44.967Z",
        degree: "computer-science",
      },
      {
        id: "1689534842356",
        name: "Cletus",
        surname: "Macejkovic",
        email: "angel_muller84@gmail.com",
        birthdate: "1962-03-07T16:25:34.020Z",
        registered: "2023-06-28T17:51:11.360Z",
        degree: "physics",
      },
      {
        id: "1689534842357",
        name: "Roy",
        surname: "Langosh",
        email: "mabelle.dubuque65@yahoo.com",
        birthdate: "1985-07-13T17:19:13.135Z",
        registered: "2022-09-25T13:30:55.464Z",
        degree: "history",
      },
    ];
    for (const asset of assets) {
      asset.docType = "asset";
      await ctx.stub.putState(asset.id, Buffer.from(JSON.stringify(asset)));
      console.info(`Asset ${asset.id} initialized`);
    }
  }

  async registerAsset(ctx, name, surname, email, birthdate) {
    const asset = {
      id: faker.string.uuid(),
      name,
      surname,
      email,
      birthdate,
      registered: new Date(),
    };
    ctx.stub.putState(id, Buffer.from(JSON.stringify(asset)));
    return JSON.stringify(asset);
  }

  async getAsset(ctx, id) {
    const assetJSON = await ctx.stub.getState(id);
    if (!assetJSON || assetJSON.length === 0) {
      throw new Error(`The asset ${id} does not exist`);
    }
    return assetJSON.toString();
  }

  async getAllAssets(ctx) {
    const allResults = [];
    const iterator = await ctx.stub.getStateByRange("", "");
    let result = await iterator.next();
    while (!result.done) {
      const strValue = Buffer.from(result.value.value.toString()).toString(
        "utf8"
      );
      let record;
      try {
        record = JSON.parse(strValue);
      } catch (err) {
        console.log(err);
        record = strValue;
      }
      allResults.push({ key: result.value.key, record });
      result = await iterator.next();
    }
    return JSON.stringify(allResults);
  }
}

module.exports = RegisterStudents;
