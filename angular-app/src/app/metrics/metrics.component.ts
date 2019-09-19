import { Component, OnInit } from '@angular/core';

import { HeaderService } from '../services/header.service';
import { BaseResult, COResult, JsonService, MLAlgorithm } from '../services/json.service';

@Component({
  selector: 'app-metrics',
  templateUrl: './metrics.component.html',
  styleUrls: ['./metrics.component.css']
})
export class MetricsComponent implements OnInit {
  public MLAlgorithms: BaseResult[] = [];
  public numChecks = 0;
  public MLADataPath = '../assets/MLData.json';
  public COResultsDataPath = '../assets/CommonData.json';

  constructor(private jsonService: JsonService) { }

  ngOnInit() {
    this.getMLAlgorithmsData();
    this.getJSONCOResultsData();
  }

  getMLAlgorithmsData() {
    this.jsonService.getJSONMLAD(this.MLADataPath)
      .subscribe((MLAlgorithms: MLAlgorithm[]) => {
        this.MLAlgorithms = this.MLAlgorithms.concat(MLAlgorithms);

        this.numChecks = this.MLAlgorithms[1].data.length;
      });
  }

  getJSONCOResultsData() {
    this.jsonService.getJSONCO(this.COResultsDataPath)
      .subscribe((COResultData: COResult) => {
        this.MLAlgorithms.unshift(COResultData);
      });
  }
}
