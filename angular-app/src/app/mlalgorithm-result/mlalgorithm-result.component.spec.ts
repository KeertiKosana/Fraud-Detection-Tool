import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MlalgorithmResultComponent } from './mlalgorithm-result.component';

describe('MlalgorithmResultComponent', () => {
  let component: MlalgorithmResultComponent;
  let fixture: ComponentFixture<MlalgorithmResultComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MlalgorithmResultComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MlalgorithmResultComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
