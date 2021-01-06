import { Component, OnInit } from '@angular/core';
import Web3 from 'web3';
import {FormsModule} from '@angular/forms'

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})

export class HomeComponent implements OnInit {
  gacha: any;
  error: string;
  option: number;
  result: any;
  contract = "0x132D85a9bf086F346Da22ca34f6E62792f2b3328";
  account: any;
  constructor() {}

  ngOnInit():void {
    this.option = 0;
    this.asyncloaded();
  }
    async asyncloaded() {
    var web3 = new Web3(Web3.givenProvider); // provider from metamask
    var result = await web3.eth.requestAccounts().catch(x => console.log(x.message));
    console.log(web3.version); // note: use  (back quote)
    const network = await web3.eth.net.getId().catch(reason => console.log(reason));
    if (typeof network === 'undefined' || network != 4) { console.log("Please select Rinkeby test network"); return; }
    console.log("Ethereum network: Rinkeby")
    var accounts = await web3.eth.getAccounts();
    this.account = accounts[0];
    console.log(accounts[0]); // show current user.
    this.gacha = new web3.eth.Contract( [
      {
        "inputs": [
          {
            "internalType": "uint256",
            "name": "pull",
            "type": "uint256"
          }
        ],
        "name": "Start",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "anonymous": false,
        "inputs": [
          {
            "indexed": false,
            "internalType": "string",
            "name": "CharName",
            "type": "string"
          },
          {
            "indexed": false,
            "internalType": "uint8",
            "name": "Rating",
            "type": "uint8"
          }
        ],
        "name": "WantGachaPull",
        "type": "event"
      },
      {
        "inputs": [
          {
            "internalType": "uint256",
            "name": "",
            "type": "uint256"
          }
        ],
        "name": "PullResult",
        "outputs": [
          {
            "internalType": "string",
            "name": "naam",
            "type": "string"
          },
          {
            "internalType": "uint8",
            "name": "Rating",
            "type": "uint8"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      }
    ], this.contract);  
      
}

  Start(amount:number) {
    this.gacha.methods.Start(amount).send({from:this.account}).then((res: any) => {
      console.log(res.events.WantGachaPull);
      if (amount == 1){this.result = [res.events.WantGachaPull];}
      if (amount == 10){this.result = res.events.WantGachaPull;}
      console.log(this.result)
    }).catch((err: any) => {
      console.error(err);
    });
  }
}