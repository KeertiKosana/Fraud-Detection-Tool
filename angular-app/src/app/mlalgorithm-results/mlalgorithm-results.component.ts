import {Component, OnInit} from '@angular/core';

import {HeaderService} from '../services/header.service';
import {JsonService, MLAlgorithm} from '../services/json.service';

@Component({
  selector: 'app-mlalgorithm-results',
  templateUrl: './mlalgorithm-results.component.html',
  styleUrls: ['./mlalgorithm-results.component.css']
})
export class MlalgorithmResultsComponent implements OnInit {
  public MLAlgorithms: MLAlgorithm[] = [];
  public MLADataPath = '../assets/MLData.json';
  // public MLADataPath = '../assets/MLD-01.json';

  constructor(private jsonService: JsonService) {}

  ngOnInit() {
    this.getMLAlgorithmsData();
  }

  getMLAlgorithmsData() {
    this.jsonService.getJSONMLAD(this.MLADataPath)
        .subscribe((MLAlgorithms: MLAlgorithm[]) => {
          this.MLAlgorithms = MLAlgorithms;
        });
  }
}
