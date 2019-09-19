import {AfterViewInit, ChangeDetectorRef, Component, ElementRef, Input, OnInit, ViewChild} from '@angular/core';
import {ListSortFieldSelectorModel} from '@blackbaud/skyux/dist/core';
import {Chart} from 'chart.js';

import {HeaderService} from '../services/header.service';
import {MLAData, MLAlgorithm, User} from '../services/json.service';

import {materialColors, ScatterChartOptions} from './scatterchart-options';

export interface Dataset {
  label: string;
  backgroundColor: string;
  borderColor: string;
  data: Point[];
}
export interface Point {
  x: number;
  y: number;
}
@Component({
  selector: 'app-mlalgorithm-result',
  templateUrl: './mlalgorithm-result.component.html',
  styleUrls: ['./mlalgorithm-result.component.css']
})
export class MlalgorithmResultComponent implements OnInit, AfterViewInit {
  @Input() public mlalgorithm: MLAlgorithm;
  public _SelectedData: MLAData[] = [];
  public DisplayedData: MLAData[] = [];
  selectedUser: User;
  ItemsPerPage: number = 10;
  @Input()
  CurrentPage: number = 1;
  ItemNumber: number = this.ItemsPerPage * 2;
  CurSortField:
      ListSortFieldSelectorModel = {fieldSelector: 'outlier', descending: true};

  @ViewChild('LCanvas', {read: ElementRef}) LCanvasRef: ElementRef;
  @ViewChild('RCanvas', {read: ElementRef}) RCanvasRef: ElementRef;

  LChart: Chart;
  RChart: Chart;

  @Input()
  set SelectedData(selectedData: MLAData[]) {
    this._SelectedData = this.sortData(selectedData, this.CurSortField);
    this.ItemNumber = this._SelectedData.length;
    this.updateDisplayedData();

    let tmpSelectedUserID: string =
        ((this.selectedUser && this.selectedUser.USERSID !== -1) ?
             this.selectedUser.USERSID.toString() :
             '');
    let chartData = (this.selectedUser && this.selectedUser.USERSID !== -1) ?
        this.SelectedData :
        undefined;
    this.setChartData(new ScatterChartOptions(
        this.RCanvasRef, this.RChart, this.makeDataPoints, chartData, undefined,
        undefined, this.mlalgorithm.localTitle + tmpSelectedUserID));
  }
  get SelectedData() {
    return this._SelectedData;
  }

  constructor(
      private headerService: HeaderService, private elementRef: ElementRef,
      private changeDetector: ChangeDetectorRef) {}

  ngOnInit() {
    this.SelectedData = this.getUserMLAData(this.selectedUser);
    this.RChart = this.initChart(new ScatterChartOptions(
        this.RCanvasRef, undefined, undefined, undefined, undefined, undefined,
        this.mlalgorithm.localTitle));

    this.headerService.getState().subscribe((selectedUser: User) => {
      this.selectedUser = selectedUser;
      this.SelectedData = this.getUserMLAData(this.selectedUser);
    });
  }

  ngAfterViewInit() {
    this.LChart = this.initChart(new ScatterChartOptions(
        this.LCanvasRef, undefined, this.makeDataPoints, this.mlalgorithm.data,
        undefined, undefined, this.mlalgorithm.globalTitle));

    let tmpSelectedUserID: string =
        (this.selectedUser ? this.selectedUser.USERSID.toString() : '');
    this.setChartData(new ScatterChartOptions(
        this.RCanvasRef, this.RChart, this.makeDataPoints, this.SelectedData,
        undefined, undefined, this.mlalgorithm.localTitle + tmpSelectedUserID));
  }

  getUserMLAData(user: User) {
    let data = this.mlalgorithm.data.filter((UserMLAData: MLAData) => {
      if (user && user.USERSID !== -1)
        return UserMLAData.userID === user.USERSID;
      else
        return true;
    });
    return data;
  }

  getPageItems(items: any[], curPage: number, itemsPerPage: number) {
    let begIdx = (curPage - 1) * itemsPerPage;
    let endIdx = begIdx + itemsPerPage;
    return items.slice(begIdx, endIdx);
  }

  updateDisplayedData() {
    this.DisplayedData = this.getPageItems(
        this.SelectedData, this.CurrentPage, this.ItemsPerPage);
  }

  updateItemsNumber() {
    this.updateDisplayedData();
  }

  makeDataPoints(data: MLAData[], labels: any[], colors: any[]) {
    let colorsArray: string[] =
        ['#e8554e', '#03A9F4', '#2aa876', '#ffd265', '#f19c65'];
    if (data) {
      if (data.length > 0 && data[0].cluster) {
        let datasets: Dataset[] = [];
        let clusters: Object = {};
        let clusterIds: string[] = [];
        for (let i = 0; i < data.length; ++i) {
          let entry: MLAData = data[i];
          let clusterId: number = entry.cluster;
          if (!clusters.hasOwnProperty(clusterId)) {
            clusters[clusterId] = [];
            clusterIds.push(clusterId.toString());
          }
          clusters[clusterId].push({x: entry.xCoord, y: entry.yCoord});
        }
        clusterIds.sort();
        for (let i = 0; i < clusterIds.length; ++i) {
          let clusterId: string = clusterIds[i];
          let clusterIdNum: number = Number.parseInt(clusterId);
          let cluster: any[] = clusters[clusterId];
          let pointColor: string = colorsArray[clusterIdNum - 1];
          let labelName: string = (labels && labels[clusterIdNum]) ?
              labels[clusterIdNum] :
              clusterId;
          datasets.push({
            label: labelName,
            backgroundColor: pointColor,
            borderColor: pointColor,
            data: cluster
          });
        }
        return datasets;
      } else {
        let datasets: Dataset[] = [];
        let outliers: Object = {};
        let outlierIDs: string[] = [];

        for (let i = 0; i < data.length; ++i) {
          let entry: MLAData = data[i];
          let outlierID: number = entry.outlier;
          if (!outliers.hasOwnProperty(outlierID)) {
            outliers[outlierID] = [];
            outlierIDs.push(outlierID.toString());
          }
          outliers[outlierID].push({x: entry.xCoord, y: entry.yCoord});
        }
        outlierIDs.sort();

        for (let i = 0; i < outlierIDs.length; ++i) {
          let outlierID: string = outlierIDs[i];
          let outlierIdNum: number = Number.parseInt(outlierID);
          let outlier: any[] = outliers[outlierID];
          let pointColor: string = colorsArray[(outlierIdNum == 0 ? 1 : 0)];
          let labelName: string = (labels && labels[outlierIdNum]) ?
              labels[outlierIdNum] :
              outlierID;
          datasets.push({
            label: labelName,
            backgroundColor: pointColor,
            borderColor: pointColor,
            data: outlier
          });
        }

        return datasets;
      }
    }
    return [];
  }

  setChartData(opts: ScatterChartOptions) {
    if (opts.ChartObj) {
      opts.ChartObj.data.datasets =
          (opts.DataFunction ?
               opts.DataFunction(opts.Data, opts.DataLabels, opts.LineColors) :
               undefined);
      if (opts.ChartTitle)
        opts.ChartObj.config.options.title.text = opts.ChartTitle;
      opts.ChartObj.update();
    }
  }

  /* customLegendHover =
      function(e, legendItem) {
    let index = legendItem.datasetIndex;
    let ci = this.chart;
    if (!ci.hasOwnProperty('prevHoverLegend')) {
      ci['prevHoverLegend'] = -1;
    }
    if (ci['prevHoverLegend'] !== index) {
      ci['prevHoverLegend'] = index;
      let etcDatasets = [];
      for (let i = 0; i < ci.data.datasets.length; ++i) {
        if (i !== index) etcDatasets.push(ci.getDatasetMeta(i));
      }
      for (let i = 0; i < etcDatasets.length; ++i) {
        let meta = etcDatasets[i];
        meta.hidden = true;
      }
      ci.getDatasetMeta(index).hidden = false;
      ci.update();
    }
  } */

  initChart(opts: ScatterChartOptions) {
    let CanvasCtx = opts.CanvasRef.nativeElement.getContext('2d');
    let ChartObj = new Chart(CanvasCtx, {
      type: 'scatter',
      data: {
        datasets: (
            opts.DataFunction ?
                opts.DataFunction(opts.Data, opts.DataLabels, opts.LineColors) :
                undefined)
      },
      options: {
        scales: {
          xAxes: [{
            type: 'linear',
            position: 'bottom',
            scaleLabel: {display: true, labelString: this.mlalgorithm.xlab}
          }],
          yAxes: [{
            type: 'linear',
            // position: 'bottom',
            scaleLabel: {display: true, labelString: this.mlalgorithm.ylab}
          }]
        },
        title:
            {display: (opts.ChartTitle ? true : false), text: opts.ChartTitle},
        events: [],
        legend: {/* onHover: this.customLegendHover */}
      }
    });
    this.changeDetector.detectChanges();
    return ChartObj;
  }

  public sortData(data: any[], activeSort: ListSortFieldSelectorModel) {
    const sortField = activeSort.fieldSelector;
    const descending = activeSort.descending;
    return data
        .sort((a: any, b: any) => {
          let val1 = a[sortField];
          let val2 = b[sortField];
          if (val1 && typeof val1 === 'string') val1 = val1.toLowerCase();
          if (val2 && typeof val2 === 'string') val2 = val2.toLowerCase();
          let result = val1 > val2 ? 1 : -1;
          if (descending) {
            result *= -1;
          }
          return result;
        })
        .slice();
  }

  public sortChanged(activeSort: ListSortFieldSelectorModel) {
    this.CurSortField = activeSort;
    this._SelectedData = this.sortData(this._SelectedData, this.CurSortField);
    this.updateDisplayedData();
  }
}
